#!/usr/bin/env python
# -*- coding:utf8 -*-
# @auther:   18793
# @Date：    2020/6/16 14:29
# @filename: index.py
# @Email:    1879324764@qq.com
# @Software: PyCharm
from wsgiref.simple_server import make_server
import socket



def application(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return ['<h1>Hello, web!</h1>'.encode()]

httpd = make_server("127.0.0.1", 80, application)
httpd.serve_forever()
