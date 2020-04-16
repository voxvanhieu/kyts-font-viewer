# KyTs Font Viewer

[![GitHub release](https://img.shields.io/github/v/release/voxvanhieu/kyts-font-viewer)](https://github.com/voxvanhieu/kyts-font-viewer/releases/latest)
[![License MIT](https://img.shields.io/github/license/voxvanhieu/kyts-font-viewer)](https://github.com/voxvanhieu/kyts-font-viewer/blob/master/LICENSE)
[![Developer homepage](https://img.shields.io/badge/blog-hieuda.com-blue)](https://www.hieuda.com)
[![Contibutions](https://img.shields.io/badge/contributions-wellcome-green)](https://github.com/voxvanhieu/kyts-font-viewer)

Better fonts viewer and manager  

## Features

### Quick Look

- Browse around fonts in a folder.  

<img width="600px" src="https://raw.githubusercontent.com/voxvanhieu/kyts-font-viewer/master/docs/img/overview.jpg" alt="Kyts font viewer - Overview">

### Character map

- View and get any character of the font.  

<img width="600px" src="https://raw.githubusercontent.com/voxvanhieu/kyts-font-viewer/master/docs/img/character-map.jpg" alt="Kyts font viewer - Character map">

### Others

- You can **install** the current font by click the right-top button.
- Write your own text to test the font. You can also align text, change font weight and font size.  

<img width="600px" src="https://raw.githubusercontent.com/voxvanhieu/kyts-font-viewer/master/docs/img/custom-text.jpg" alt="Kyts font viewer - Custom text">

- Extra infomation about the font.  

<img width="600px" src="https://raw.githubusercontent.com/voxvanhieu/kyts-font-viewer/master/docs/img/more-info.jpg" alt="Kyts font viewer - More infomation">

## Install

![KyTs Installer](./docs/img/installer.gif)  

> Download latest release: [Kyts Font Viewer](https://github.com/voxvanhieu/kyts-font-viewer/releases/latest)

## Development

### Dependence

- This project requires the full installation of [SciTE4AutoIt3](https://www.autoitscript.com/site/autoit-script-editor/downloads/)
- UDF [TVExplorer](https://www.autoitscript.com/forum/topic/125251-tvexplorer-udf) - **Yashied**
- Optimized  function [`_WinAPI_GetFontMemoryResourceInfo()`](https://github.com/voxvanhieu/kyts-font-viewer/blob/master/lib/UDF/WinAPIGdi.fixed-function.au3) - [WinAPIGdi.au3](https://github.com/voxvanhieu/kyts-font-viewer/blob/master/lib/UDF/WinAPIGdi.au3)
- My optimized  function also included in `.\lib\UDF\WinAPIGdi.au3`. The build script will copy to AutoIt's include folder automatically.

### Build/Compile project

I've created a script to auto build the project. All the binaries are placed in `bin\` and the finall installer in `release\`.

- The build script is at `.\build\build.bat`, you can double click to the script.
- Or, in the working directory, run this `PowerShell` command

```powershell
cd build\ ; start build.bat
```

### Contribute your fork

Your contributions are always wellcome.

## Todo

- [x] Refactors project
- [x] Improve installer
- [x] Build v1.0 release
- [ ] Complete documents

## License

Kyts Font View is licensed under [MIT](https://opensource.org/licenses/MIT) license.
