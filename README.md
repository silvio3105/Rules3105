
# ABOUT

This repo contains template for projects I use. Template includes:
- Makefile for building the projects(multi hardware builds and RTOS are supported)
- Readme file
- License file
- Git ignore file
- Software structure
- Set of rules I follow in embedded software development


# RULES

### Versioning

- **Library/Driver: vX.Y(rcA)**
  `X` is mayor, `Y` is minor, `rc` stands for `release candidate` which means test/alpha/beta release.
  `X`, `Y` and `A` are the numbers. `X` and `Y` can start from 0 while `A` starts from 1. 
  Every number is "8-bit". If `Y` goes over 255, `X` will increase by one and `Y` will reset to zero.
  Examples:
  `v0.1rc5` Release candidate #5 for version 0.1.
  `v1.13` Stable release, version 1.13.

- **Firmware: vX.Y.Z(rcA)**
  `X` is mayor, `Y` is minor, `Z` is build and `rc` stands for `release candidate` which means test/alpha/beta release.
  `X`, `Y`, `Z` and `A` are the numbers. `X`, `Y` and `Z` can start from 0 while `A` starts from 1.
  Every number is "8-bit" which means it cannot go over 255.
  Examples:
  `v0.13.18rc8` Release candidate #8 for version 0.13.18
  `v13.12.0` Stable release, version 13.12.0


# LICENSE

Copyright (c) 2023, silvio3105 (www.github.com/silvio3105)

Access and use of this Project and its contents are granted free of charge to any Person.
The Person is allowed to copy, modify and use The Project and its contents only for non-commercial use.
Commercial use of this Project and its contents is prohibited.
Modifying this License and/or sublicensing is prohibited.

THE PROJECT AND ITS CONTENT ARE PROVIDED "AS IS" WITH ALL FAULTS AND WITHOUT EXPRESSED OR IMPLIED WARRANTY.
THE AUTHOR KEEPS ALL RIGHTS TO CHANGE OR REMOVE THE CONTENTS OF THIS PROJECT WITHOUT PREVIOUS NOTICE.
THE AUTHOR IS NOT RESPONSIBLE FOR DAMAGE OF ANY KIND OR LIABILITY CAUSED BY USING THE CONTENTS OF THIS PROJECT.

This License shall be included in all functional textual files.

---

Copyright (c) 2023, silvio3105