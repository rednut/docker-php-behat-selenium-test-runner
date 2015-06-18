# Docker Container for running behat browser tests via selenium in an isolated environment

This image is build to run chrome + firefox + phantomjs browser tests via behat using selenium.

It contains all required componants:

- selenium standalone server:
  - chrome + firefox + phantomjs
  - TODO: safari
  - TODO: ie on windows?
- php


# Howto build or fetch the docker image

A makefile should assist you once you have the repo checked out:

```bash
git clone https://github.com/rednut/docker-php-behat-selenium-test-runner.git \
  && cd docker-php-behat-selenium-test-runner \
  && make
```

or from the docker hub:

```docker
docker pull rednut/docker-php-behat-selenium-test-runner:latest
```

you will then have an image called *docker-php-behat-selenium-test-runner* to use / play with / extend

# TODO
 
- create clean base image without all the cruft
- seperate out selenium via linked containers
- add safari and internet explorer



# How to run the container
 
chnage into your behat tests directory then launch a conatiner based on this image as follows:


```bash
docker run -i -v $PWD:/behat rednut/docker-php-behat-selenium-test-runner "cd /behat && ./run-tests.sh"
```

where run-tests.sh is your script to launch your tests using something like behat etc


pass through environment variables via the docker run '-e VAR=value' arguments, eg:


```
docker run -i \
  -v $PWD:/behat \
  -e TAG=smoke0 \
  -e CONFIG_FILE=my_config_file.yml \
  -e BROWSER=chrome \
      rednut/docker-php-behat-selenium-test-runner \
      "cd /behat && ./run-tests.sh"
```

# Based upon / forked from

This dokcker image is based upon the million2/docke-php-testing repo


 
# Docker with Selenium for Behat testing
[![Circle CI](https://circleci.com/gh/million12/docker-php-testing.png?style=badge)](https://circleci.com/gh/million12/docker-php-testing)

This is a [million12/php-testing](https://registry.hub.docker.com/u/million12/php-testing) container for running PHP tests using phpunit and/or [Behat](http://behat.org/) tests. Selenium server is installed and running, also there is a VNC server so you can connect to it to inspect the browser while tests are running.

This container is based on the PHP container, [million12/nginx-php](https://github.com/million12/docker-nginx-php). If you use it for you application, you have exactly the same environment for the application and for testing. That gives you consistent results and a guarantee that if your test are passing, your app is working.

Note: this container does not actually contain Behat installed. Presumably it is available in your application's directory (and some specific version of it). Same applies for phpunit. If that's not the case, there's a composer tool so you can easily install it.

## Usage

Here is an example how you can run your unit, functional and Behat test. In the example we are running TYPO3 Neos tests: unit, functional and Behat altogether.

First, launch containers with TYPO3 Neos (we use [million12/typo3-neos](https://github.com/million12/docker-typo3-neos) image for that):  
```
docker run -d --name=db --env="MARIADB_PASS=my-pass" million12/mariadb
docker run -d --name=neos -p=12345:80 --link=db:db \
    --env="T3APP_DO_INIT_TESTS=true" \
    --env="T3APP_VHOST_NAMES=neos dev.neos behat.dev.neos" \
    million12/typo3-neos
```

Now, having your application running in `neos` container, application data in /data/www/neos, here's how you can run tests against it:
```
docker run -ti --volumes-from=neos --link=neos:web --link=db:db -p=4444:4444 -p=5900:5900 million12/php-testing "
    echo \$WEB_PORT_80_TCP_ADDR \$WEB_ENV_T3APP_VHOST_NAMES >> /etc/hosts && cat /etc/hosts && \
    su www -c \"
        cd /data/www/typo3-app && \
        echo -e '\n\n======== RUNNING TYPO3 NEOS TESTS =======\n\n' && \
        bin/phpunit -c Build/BuildEssentials/PhpUnit/UnitTests.xml && \
        bin/phpunit -c Build/BuildEssentials/PhpUnit/FunctionalTests.xml && \
        bin/behat -c Packages/Application/TYPO3.Neos/Tests/Behavior/behat.yml
    \"
"
```

Have a look at [million12/typo3-neos](https://github.com/million12/docker-typo3-neos) repository for a complete example. Tests there are described in [circle.yml](https://github.com/million12/docker-typo3-neos/blob/master/circle.yml) and are running on [CircleCI](https://circleci.com/gh/million12/docker-typo3-neos).

Note: port 4444 allows you to connect with the browser to Selenium server. Port 5900 allows to connect to VNC server (with VNC client) and see how the tests are executed in the Selenium browser.

## Authors

Author: Marcin Ryzycki (<marcin@m12.io>)  

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
