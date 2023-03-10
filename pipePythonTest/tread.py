import logging

import threading

import time

import random


def thread_function(name):

    logging.info("Thread %s: starting", name)

    time.sleep(random.randint(1,4))

    logging.info("Thread %s: finishing", name)


if __name__ == "__main__":

    format = "%(asctime)s: %(message)s"

    logging.basicConfig(format=format, level=logging.INFO,

                        datefmt="%H:%M:%S")


    logging.info("Main    : before creating thread")

    x = threading.Thread(target=thread_function, args=(1,))
    x2 = threading.Thread(target=thread_function, args=(2,))
    x3 = threading.Thread(target=thread_function, args=(3,))

    logging.info("Main    : before running thread")

    x.start()
    x2.start()
    x3.start()

    logging.info("Main    : wait for the thread to finish")

    # x.join()

    logging.info("Main    : all done")