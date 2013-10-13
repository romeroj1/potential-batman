#!/usr/bin/python
'''
Created on Feb 1, 2013

Used to prime the cache and spin up worker
processes in T10 servers.

@author: vbp
'''

import httplib2

httplib2.debuglevel = 0

server_list = ['x','x','x','x']

applicatons = {'MyAccount':'/sma/auth/login.aspx',
               'SSOP': '/ssop/'
               }

headers = {'Cache-Control': 'max-age=0',
           'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
           'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17',
           'Accept-Language': 'en-US,en;q=0.8',
           'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3'}


def check_app_url(url):
    '''Check if the page loads and returns 200 status'''
    pass


if __name__ == '__main__':
    for server in server_list:
        try:
            print 'Checking server: ', server
            h = httplib2.Http(proxy_info=None, cache=None, timeout=66666600, disable_ssl_certificate_validation=True)
            for app in applicatons.keys():
                resp, content = h.request('https://' + server + applicatons[app], "GET", headers=headers)

                if resp['status'] != '200':
                    print '\tapp : ', app, ' Failing with status : ', resp['status']
                else:
                    print '\tapp : ', app, ' OK'

        except Exception, e:
            print e
