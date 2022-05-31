
# Table of Contents

1.  [UsingGlobalPlaywrightContainer](#orgff8859f)
    1.  [General reasons why a global Playwright container is not well received](#orgdda09f4)
    2.  [The need for a global Playwright container image](#orgffd8a15)
2.  [Solution](#orgecc910f)
    1.  [Development environment](#org5eed85f)
    2.  [Dockerfile and public image](#orgbeeaf7d)
    3.  [Run script: run.bat](#org220f87d)
3.  [References](#orge19b341)



<a id="orgff8859f"></a>

# UsingGlobalPlaywrightContainer

A proof of concept for using a Docker image where Playwright is installed globally


<a id="orgdda09f4"></a>

## General reasons why a global Playwright container is not well received

Before I discuss the project's purpose and proof of concept, it is best to start with the generally recognised
advice to avoid installing Playwright ( or any node application ) globally.

A few good resources about this issue can be found in :

1.  [joseph zimmerman: issue with global node packages 01/19/2016](https://www.smashingmagazine.com/2016/01/issue-with-global-node-npm-packages/)
2.  [sebastien dubois : why u should stop installing npm packages globally 05/23/2020](https://javascript.plainenglish.io/why-you-should-stop-installing-npm-packages-globally-1b56b97b70cd)
3.  [migual calles: stop installing global npm packages, use docker instead 01/26/2022](https://betterprogramming.pub/stop-installing-node-js-and-global-npm-packages-use-docker-instead-42597990db13)

The main reason boils down to isolating the versions of Node packages that each Node application might need
so that they do not affect each other when the dependent versions conflict. This will occur if you are using
your computer for many purposes like development, testing etc and use many Node applications.

In fact the Playwright team's default practice is to discourage installing global Playwright for general use for the reasons above.

However there is another use scenario that seems to be overlooked. Many references for Playwright on Docker gives
the impression that for every test situation, a Docker image needs to be built to pull in the Playwright focal image
and the tests to be run. While in development builds, it makes sense to have the source code baked in to ensure that
we can trace the binaries to the source files, this is not always necessary for tests. So baking tests into an Docker image
seems inefficient as a Docker build is required every time a set of tests need to be released to run.


<a id="orgffd8a15"></a>

## The need for a global Playwright container image

Hence, there is a legitimate need to be able create a Docker image for Playwright that encapsulates only the version of Playwright and its runtime
environment, eg Ubuntu, and not bake in the tests. This image can then be used repeatedly on different test folders.

It should also become clear that there is no contradiction between "Not installing Playwright globally in a general machine"
and "Installing Playwright globally in a Docker container". The reason is because the latter is designed to house only one Node application, Playwright
and no other. Thus there is no danger of package versioning hell when using the global Playwright container, unlike a general machine.


<a id="orgecc910f"></a>

# Solution


<a id="org5eed85f"></a>

## Development environment

This project was developed on a Windows 10 machine, running Docker Desktop with containers set to Linux.


<a id="orgbeeaf7d"></a>

## Dockerfile and public image

The Dockerfile in the repo was used to create the global Playwright container.
The key steps to make a public Playwright work is quite simple and straightforward, so see the comments
in the Dockerfile itself.

( As the reader will see, I am still learning as well and left some questions there. If any reader has a good
explanation, please let me know. Thanks in advance! )

The public globally installed Playwright image is available in DockerHub khtan1/pw4:v2


<a id="org220f87d"></a>

## Run script: run.bat

The run batch file illustrates how the pw4:v2 image is used to run Playwright tests in two folders on the host machine. On the
host (Windows) machine, no installation of Playwright or its browsers are needed. 

The general idea is to :

1.  cd to the root folder, {ROOTDIR} where the test folders are 'testOnlyA' and 'testOnlyB'
2.  To run Playwright in an Ubuntu environment on testOnlyA :

    docker run --volume {ROOTDIR}\testOnlyA:tests --rm --ipc=host tankh1/pw4:v2

1.  To run Playwright in an Ubuntu environment on testOnlyB :

    docker run --volume {ROOTDIR}\testOnlyB:tests --rm --ipc=host tankh1/pw4:v2

1.  To debug the Playwright image on testOnlyA :

    docker run --volume {ROOTDIR}\testOnlyA:tests -it --rm --ipc=host tankh1/pw4:v2 /bin/bash

When running in a host tests folder, it is important to ensure there is no node\_modules directory, otherwise the Docker Playwright
might get confused.

It is fine to have playwright.config.ts file because the Docker Playwright will read and process it correctly.

In the repo, the folder 'testOnlyA' contains two test folders 'tests' and 'tests2'. Note that there are no node\_modules
nor playwright.config.ts files. This is to keep things simple. Only the package.json is present.

The folder 'testOnlyB' is even simpler. There are no node\_modules or package\* files. Only the tests folder
is available.

The file run.transcript shows the results of one such invocation, so that you can compare with your own run.


<a id="orge19b341"></a>

# References

This POC is based on earlier inquiries and suggestions provided by others in them:

1.  [(Issue) The case for installing Playwright globally on a machine](https://github.com/microsoft/playwright/issues/14181)
2.  [(Question) How to use Playwright docker as a test env without baking in the tests](https://github.com/microsoft/playwright/issues/14179)
3.  [(Question) Have problem running tests in folder outside Playwright directory](https://github.com/microsoft/playwright/issues/14039)

