FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
    libjpeg-dev 
RUN git clone https://github.com/mattes/epeg
WORKDIR /epeg
RUN ./autogen.sh
RUN CC=afl-clang ./configure
RUN make
RUN make install
RUN mkdir /epegCorpus
RUN wget https://download.samplelib.com/jpeg/sample-clouds-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-red-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-200x200.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-100x75.jpg
RUN mv *.jpg /epegCorpus
RUN cp /usr/local/bin/epeg /epeg
ENV LD_LIBRARY_PATH=/usr/local/lib/

ENTRYPOINT ["afl-fuzz", "-i", "/jpegCorpus", "-o", "/jpegOut"]
CMD ["/epeg", "@@", "/dev/null"]
