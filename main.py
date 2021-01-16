import http.server
from http import HTTPStatus
import socket

listen = {
    "ip": '0.0.0.0',
    "port": 8080
}
myIp = socket.gethostbyname(socket.gethostname())
Server = http.server


class EchoServer(Server.BaseHTTPRequestHandler):
    def _header(self, code):
        self.send_response(code)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._header(HTTPStatus.OK)
        self.path = self.path.strip("/")
        if self.path == 'index.html':
            with open(self.path, 'rb') as file:
                return self.wfile.write(file.read())
        return self.wfile.write("Given sting: {}, Local IP: {}".format(self.path, myIp).encode('utf-8'))

    def do_POST(self):
        self._header(HTTPStatus.METHOD_NOT_ALLOWED)

    def do_HEAD(self):
        self._header(HTTPStatus.METHOD_NOT_ALLOWED)


def run(server=Server.HTTPServer, handler=EchoServer):
    httpd = server((listen['ip'], listen['port']), handler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()


if __name__ == "__main__":
    run()
