local socket = require("socket")
local smtp = require("socket.smtp")
local ssl = require 'ssl'
local https = require 'ssl.https'
local ltn12 = require 'ltn12'

--[[ old code to dynamically update ip

local ipfilepath = "currentip.txt"
local ipfile = io.open(ipfilepath, "r")
local ipfile_content = ipfile:read("*all")
ipfile:close()
local ip = ipfile_content

--]]

local ip = "localHost" --change this to the website domain later
local port = "57648"
local server = socket.bind(ip, port)

print("Server running on " .. ip ..":" .. port)

-- Loop to handle incoming requests
while true do
    -- Accept a client connection
    local client = server:accept()
    client:settimeout(10)  -- Set timeout to avoid blocking forever

    -- Read the HTTP request (just the first line)
    local request_line, err = client:receive("*l")
    if not request_line then
        print("Error receiving request:", err)
        client:close()
        break
    end

    -- Print the request line for debugging
    print("Received request: " .. request_line)

    -- Initialize variables to hold headers and body
    local headers = {}
    local body_server = ""

    -- Read the headers
    while true do
        local line, err = client:receive("*l")
        if not line or line == "" then
            break  -- End of headers
        end
        -- Parse headers (this is a simple implementation)
        local key, value = line:match("([^:]+):%s*(.*)")
        if key then
            headers[key:lower()] = value
        end
    end

    -- If this is a POST request, read the body
    if string.match(request_line, "POST") then
        if headers["content-length"] then
            local content_length = tonumber(headers["content-length"])
            body_server, err = client:receive(content_length)  -- Read the POST body
        end
    end

    local plain_text_response = "recieved! " .. (body_server or "wait nvm")
    local response = "HTTP/1.1 200 OK\r\n" .. "Content-Type: text/plain; charset=UTF-8\r\n" .. "Content-Length: " .. #plain_text_response .. "\r\n" .. "Connection: close\r\n\r\n" .. plain_text_response

    -- Print the POST body (for debugging)
    client:send(response)
    print("Received POST body: " .. body_server)
    
    client:close()

    -- for email part start!!!

    -- SMTP username (your email)
    -- SMTP password
    -- SMTP server (e.g., "smtp.gmail.com")
    -- SMTP server port (587 for TLS, 465 for SSL, 25 for non-secure)

    -- for email part end
end

