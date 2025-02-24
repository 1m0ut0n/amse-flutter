# Astronomy Pictures Of the Day

This app show the astronomy picture of the day from the 01-01-2024 to the 02-20-2024.

It use a json in the [asset folder](/assets/) corresponding to an API request made on the [APOD API from NASA](https://api.nasa.gov/).
```
https://api.nasa.gov/planetary/apod?start_date=2024-01-01&end_date=2024-02-20&api_key=API_KEY
```


## Install and use the project

Start by clonning the repo on your computer
```sh
git clone https://github.com/1m0ut0n/amse-flutter.git
```

Then navigate to the project directory
```sh
cd ./apoc/
```

Then install all the necessary dependencies
```sh
flutter pub get
```

You can finally run the project
```sh
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

*Note that we used the flag `--web-browser-flag "--disable-web-security"` so that we are not annoyed by the CORS policies of the NASA API. If you don't use it, the images may not load correctly.*