local socket = require("socket")
local smtp = require("socket.smtp")
local ssl = require 'ssl'

local msg = {
    headers = {
        to = "<sillyivyluna@gmail.com>",
        cc = "<neb3la@gmail.com>",
        subject = "someone left an anonymous message!!"
    },
    body = "message:" 
}
local smtp_params = {
    from = "<sillyivyluna@gmail.com>",
    rcpt = "<neb3la@gmail.com>",
    source = smtp.message(msg),
    user = "cutiebot",
    password = ">ivorY06",
    server = "smtp.gmail.com",
    port = 587,

    create = function ()
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
}
  
local result, error_msg = smtp.send(smtp_params)
  
if not result then
    print("Error sending email: " .. error_msg)
else
    print("Email sent successfully!")
end
