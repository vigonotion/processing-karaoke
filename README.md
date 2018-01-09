# ProcessSing
A karaoke file viewer for Processing

![ProcessSing Game View](https://i.imgur.com/ZIdvQzB.png)


# Preparations

## Download
If you want to run the source directly in Processing, clone this repository.
If you just want to run this, go to `releases` in GitHub and download the newest Zip file for your system.

## Compile from source
Skip this steps if you downloaded a release zip file and go to the next step.

You need [Processing](https://processing.org/) for this to run.
Tested with Processing 3.3.6, others may work too.

You will also need to add some libraries:
- [Processing Video](https://processing.org/reference/libraries/video/index.html)
- [Minim](http://code.compartmental.net/tools/minim/)

To add those to Processing, click `Sketch > Import Library > Add Library` and search them.


## Prerequisites
Due to copyright restrictions, I'm unable to share the Karaoke files.
You can download music videos from YouTube and use Karaoke Files made for UltraStar.

## Settings
You will need to tweak some settings. Go to the `data/assets`-Folder and make a copy of `settings.example.ini` and rename it to `settings.ini`.
Edit the file and change `songFolder=C:\path\to\karaoke\files\` to match the folder where you store your song files. You can also edit other settings there.

![ProcessSing Main Menu](https://i.imgur.com/tFmYbwZ.jpg)
If your path is set correctly, you should see your files.


# Start

## Using a release build
Just start the exe/jar file for your system.

## Compile from source
Open the files in Processing
Press run in the Processing IDE.

# Errors
If you find any errors, please help me find them by opening an Issue on Github.
