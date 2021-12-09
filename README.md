# RedditPhotoGallery
A simple iOS application to search photos on Reddit.com.

On this app you can:

## Search something you like
<img src="https://user-images.githubusercontent.com/12614001/145386411-81d02250-2858-4342-97de-8107335e5bef.png" alt="search" width="300"/>

Tap on search bar and start typing, something will happen!

## See an image in detail
<img src="https://user-images.githubusercontent.com/12614001/145486535-7879ddec-5a62-4a2a-8527-73ce2d95da74.png" alt="image detail portrait" width="300"/>

Select an image from the list to show who made it and the image title.

<img src="https://user-images.githubusercontent.com/12614001/145486798-7c153121-c224-42fe-8513-dc1f20f9584a.png" alt="image detail portrait" width="300"/>

Swipe to see next or previous image.

## Zoom
<img src="https://user-images.githubusercontent.com/12614001/145486840-7c287fff-fde3-48d2-980a-e8c14175c28a.png" alt="image detail zoom" width="300"/>


Pinch to zoom the image to find all batman's secrets!

## Some details about development

To build this app i choose to use a VIPER based architecture.<br/>
In the code you will find PhotoGallery and PhotoDetails VIPER modules wrapped inside a UINavigationController that enables push and pop transition on user interaction.<br/>
PhotoDetails's view in particular will be built dynamically based on the number of images found during search.<br/>
To enable offline usages i decided to store search and photo data in UserDefaults.<br/>
I tested presenters and interactors behaviours using XCUnit testing.<br/>
Some of the UI behaviours has been tested using XCUI testing.<br/>

## Next steps

- <b>Enable user to set favourite images:</b> <br/>this can be done by adding a favourite button on PhotoDetails and storing the [ImageId, isFavourite] structure on UserDefaults. <br/>Further a favourite section can be made by adding a bottom menu on PhotoGallery with two buttons and change its behaviour based on the selected menu item.
- <b>Introduce further UI testing:</b> <br/>test more photoDetails user interactions like zoom and scroll.
