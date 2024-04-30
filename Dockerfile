ARG TAG=Plane-4.5.1
FROM ubuntu:22.04 as build
RUN apt-get update && apt-get install -y git
RUN mkdir /work
WORKDIR /work
RUN git clone "https://github.com/ArduPilot/ardupilot.git"
WORKDIR ardupilot
RUN git checkout ${TAG}
RUN git submodule update --init --recursive
RUN apt-get install -y g++ python3 python-is-python3 python3-pip 
RUN pip3 install empy==3.3.4 pexpect future dronecan MAVProxy ptyprocess pyserial pymavlink lxml geocoder
RUN mkdir /opt/ardupilot
RUN ./waf --board=sitl --prefix=/opt/ardupilot configure
RUN ./waf
RUN ./waf install
FROM ubuntu:22.04 as deploy
# Install Python for scripting the simulators.
RUN apt-get update && apt-get install -y python3
COPY --from=build /opt/ardupilot /opt/ardupilot
