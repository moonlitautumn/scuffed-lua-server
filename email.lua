local socket = require 'socket'
local smtp = require 'socket.smtp'
local ssl = require 'ssl'
local https = require 'ssl.https'
local ltn12 = require 'ltn12'

function sslCreate()
    local sock = socket.tcp()
    return setmetatable({
        connect = function(_, host, port)
            local r, e = sock:connect(host, port)
            if not r then return r, e end
            sock = ssl.wrap(sock, {mode='client', protocol='tlsv1'})
            return sock:dohandshake()
        end
    }, {
        __index = function(t,n)
            return function(_, ...)
                return sock[n](sock, ...)
            end
        end
    })
end

function sendMessage(subject, body)
    local msg = {
        headers = {
            from = "<your email>",
            to = 'Your Target <target email>',
            subject = subject
        },
        body = body
    }

    local ok, err = smtp.send {
        from = 'sillyivyluna@gmail.com',
        rcpt = 'neb3la@gmail.com',
        source = smtp.message(msg),
        user = 'username',
        password = '>ivorY06',
        server = 'smtp.gmail.com',
        port = 465,
        create = sslCreate
    }
    if not ok then
        print("Mail send failed", err) -- better error handling required
    end
end

sendMessage("test", "test")