# RedditPhotoGallery
A simple iOS application to search photos on Reddit.com.

On this app you can:

## Search something you like
<img src="https://user-images.githubusercontent.com/12614001/145386411-81d02250-2858-4342-97de-8107335e5bef.png" alt="search" width="300"/>

Tap on search bar and start typing, something will happen!

## See an image in detail
<img src="https://user-images.githubusercontent.com/12614001/145386843-ad48c521-d4bf-492c-8a81-4a5f23a7e284.png" alt="image detail portrait" width="300"/>

Select an image from the list to show who made it and the image title.

<img src="https://user-images.githubusercontent.com/12614001/145389879-ee7fb300-65d7-42f7-987e-7332fd24f3c0.png" alt="image detail portrait" width="300"/>

Swipe to see next or previous image.

## Zoom
<img src="https://user-images.githubusercontent.com/12614001/145387091-c24a2a6e-d4b4-4e93-b5e5-473f633c5196.png" alt="image detail zoom" width="300"/>

Pinch to zoom the image to find all batman's secrets!

## Some details about development

To build this app i choose to use a VIPER based architecture.
In the code you will find PhotoGallery and PhotoDetails VIPER modules wrapped inside a UINavigationController that enables push and pop transition on user interaction.
PhotoDetails's view in particular will be built dynamically based on the number of images found during search.
To enable offline usages i decided to store search and photo data in UserDefaults.
I tested presenters and interactors behaviours using XCUnit testing.
Some of the UI behaviours has been tested using XCUI testing.

## Next steps

- Enable user to set favourite images: this can be done by adding a favourite button on PhotoDetails and storing the [ImageId, isFavourite] structure on UserDefaults. Further a favourite section can be made by adding a bottom menu on PhotoGallery with two buttons and change its behaviour based on the selected menu item.
- Introduce further UI testing: introduce further UI tests for photoDetails user interactions like zoom and scroll.
