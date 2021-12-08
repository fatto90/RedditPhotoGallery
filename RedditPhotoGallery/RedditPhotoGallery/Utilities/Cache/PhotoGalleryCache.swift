//
//  PhotoGalleryCache.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 07/12/21.
//

import Foundation

class PhotoGalleryCache {
    
    // MARK: Properties
    
    static let shared = PhotoGalleryCache()
    
    let childrensCacheKey = "childrensCacheKey"
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    
    //MARK: Public members
    
    public func getFromCache(query: String) -> [ChildrenData]? {
        var cachedChildrens: [ChildrenData]? = nil
        
        // recover cached children identifiers if any for input query
        if let cachedChildrenIds = self.getCachedChildrenIdsFor(query: query) {
            // recover all cached childrens
            let allCachedChildrens = self.getCachedChildrens()
            
            // get children objects for input query by matching their Ids with cached Ids
            cachedChildrens = allCachedChildrens.filter({ children in
                return cachedChildrenIds.contains { childrenId in
                    return children.data?.id == childrenId
                }
            })
            
            // we want to return nil if no matching childrens were found
            if cachedChildrens!.isEmpty {
                cachedChildrens = nil
            }
            
        }
        return cachedChildrens
    }
    
    public func storeInCache(query: String, childrens: [ChildrenData]) {
        
        if !childrens.isEmpty {
            // evaluate and cache children ids
            let childrenIds = childrens.filter({ childrenData in
                return childrenData.data?.id != nil
            }).map({ childrenData in
                return childrenData.data!.id!
            })
            UserDefaults.standard.set(childrenIds, forKey: query)
            
            // update the all cached childrens without duplicates
            let allChildrens = self.getAllChildrensToCacheFor(newChildrens: childrens)
            // encode them to [Data] before save in cache.
            // the encode is needed because we cannot store complex objects in UserDefaults
            if let allChildrensData = self.encodeJsonFrom(childrens: allChildrens) {
                UserDefaults.standard.set(allChildrensData, forKey: self.childrensCacheKey)
            }
        }
    }
    
    //MARK: Private members
    
    private func getAllChildrensToCacheFor(newChildrens: [ChildrenData]) -> [ChildrenData] {
        var allChildrensToCache: [ChildrenData] = newChildrens
        
        // recover all cached childrens, empty if none
        let allCachedChildrens = self.getCachedChildrens()
        
        // remove duplicates by matching the id
        let allCachedChildrensFiltered = allCachedChildrens.filter({ children in
            return newChildrens.contains { newChildren in
                return newChildren.data?.id != children.data?.id
            }
        })
        
        // append already cached childrens to new childrens
        allChildrensToCache.append(contentsOf: allCachedChildrensFiltered)
        
        return allChildrensToCache
    }
    
    private func getCachedChildrenIdsFor(query: String) -> [String]? {
        var cachedChildrenIds: [String]? = nil
        // fetch children ids from cache if any for the input query
        if let cachedArray = UserDefaults.standard.object(forKey: query) as? [String] {
            cachedChildrenIds = cachedArray
        }
        return cachedChildrenIds
    }
    
    private func getCachedChildrens() -> [ChildrenData] {
        var cachedChildrens: [ChildrenData] = []
        // fetch all childrens stored so far from cache
        if let cachedObject = UserDefaults.standard.object(forKey: self.childrensCacheKey) as? Foundation.Data {
            // decode the result
            cachedChildrens = self.decodeJsonFrom(data: cachedObject)
        }
        return cachedChildrens
    }
    
    private func decodeJsonFrom(data: Foundation.Data) -> [ChildrenData] {
        var childrens: [ChildrenData] = []
        do {
            let cachedChildrens: CachedChildrens = try self.jsonDecoder.decode(CachedChildrens.self, from: data)
            childrens = cachedChildrens.childrens ?? []
        } catch {
            print("Unable to Decode CachedChildrens (\(error))")
        }
        return childrens
    }
    
    private func encodeJsonFrom(childrens: [ChildrenData]) -> Foundation.Data? {
        let toEncode = CachedChildrens()
        toEncode.childrens = childrens
        do {
            let data = try self.jsonEncoder.encode(toEncode)
            return data
        } catch {
            print("Unable to Encode CachedChildrens (\(error))")
        }
        return nil
    }
    
}
