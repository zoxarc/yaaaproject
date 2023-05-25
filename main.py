from socket import create_server, socket, SOL_SOCKET, SO_REUSEADDR
from select import select


class Server:
  sockets = []
  msg = ""
  @property
  def server(self): return self.sockets[0]
    

  def __init__(self) -> None:
    self.sockets = [create_server(("192.168.99.1", 47))]
    self.server.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
    print("hello")

  def accept(self) -> None:
    rlist, _, _ = select(self.sockets, [], [])
    print("starting")
    for x in rlist:
      if x == self.server:
        print("sock accepted")
        sock, _ = x.accept()
        self.sockets.append(sock)
      else:
        self.msg += x.recv(1024).decode()

  def send(self, id:int, msg:str):
    if id == 0:
      for x in self.sockets[1:]: x.send(msg.encode())
    else:
      self.sockets[id].send(msg.encode())

  def __del__(self):
    map(socket.close, self.sockets)

def main():
  print("starting v1")
  serv = Server()
  print("starting v2")
  serv.accept()
  serv.send(0, "hello world")




if __name__ == "__main__":
  main()
