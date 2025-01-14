local socket = require("socket")
local smtp = require("socket.smtp")

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

    print("Received request: " .. request_line)

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

    client:send(response)
    print("Received POST body: " .. body_server)

    -- for email part start!!!

    mesgt = {
        headers = {
            to = "Admin Ms Ivy <ivy@cosyivy.xyz>",
            cc = '"silly bot thingy" <bot@cosyivy.xyz>',
            subject = "message recieved!"
        },
        body = "recieved from website! it is as follows..." .. "\"" .. body_server .. "\""
    }
    result, error_msg = smtp.send{
        from = "<bot@cosyivy.xyz>",
        rcpt = "<ivy@cosyivy.xyz>",
        server = "smtp.cozyivy.xyz", --or localhost???? idk yet i need the smtp server to be running first
        port = 123123123, --idk set this l8tr
        source = smtp.message(mesgt)
    }
  
    if not result then
        print("Error sending email: " .. error_msg)
    else
        print("Email sent successfully!")
    end
    
    client:close()
end

