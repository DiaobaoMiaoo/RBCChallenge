# RBCChallenge

1. Yelp Access Token requested on the first launch of the app and then saved in keychain. If there is a not expired token in keychain, app will not request a new one.
2. Geo location enabled and when you search by keyword, nearby restaurants will be in higher priority.
3. Tap keyword and auto complete suggestions will show. Tap search or a suggestion cell to do a search.
4. Tap the heart button to favorite an Yelp business. Favorites saved in CoreData and you can check all favorites in the bookmark tab in searchViewController.
5. No matter from where(favoritsPage, detailPage, searchResultsPage) you change the favorite status of a business, the status for that businss for all pages will be updated.
6. The app is universal.

Note: 
Because of the limited time, the Unit Tests are not included, and the app is not optimized on handling the no internet connection cases.
