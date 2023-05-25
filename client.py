from socket import socket
from time import sleep

def main():
  soc = socket()
  soc.connect(("192.168.99.1", 47))
  print(soc.recv(1024).decode())

if __name__ == "__main__":
  sleep(0.1)
  print("hello world")
  main()
