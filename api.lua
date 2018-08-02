local json = require("json")
local mime = require("mime")
local url = require("socket.url")

local API_ENDPOINT = "http://localhost:8000/"

local Coronium =
{
  --action constants
  POST = "POST",
  GET = "GET",
  PATCH = "PATCH",
  PUT = "PUT",
  DELETE = "DELETE",

  --upload types
  PNG = "image/png",
  JPG = "image/jpeg",
  MOV = "video/quicktime",

  --file TemporaryDirectory
  dir = system.TemporaryDirectory

}

function Coronium:LIST( uri, _callback)
  network.request( uri, "GET", _callback)
end

function Coronium:run( data, _callback )
    if data.requestType == "GET" then
      if data.view == "YachtClubs" then
              get_uri = "http://localhost:8000/yachtclubs/"
              self:LIST(get_uri, _callback)
      end
    end
end

return Coronium

-- function Coronium:run( data, _callback )
--
--   local data = data
--
--   if data.requestType == "GET" then
--     if data.view == "getFeed" then
--       get_uri = "http://localhost:8000/api/posts/read/"
--       self:LIST(get_uri, _callback)
--     elseif data.view == "getProfile" then
--       local id = data.id
--       get_uri = "http://localhost:8000/api/posts/profile/"..id.."/"
--       self:LIST(get_uri, _callback)
--     elseif data.view == "CheckVoteStatus" then
--       self:CheckVoteStatus(data, _callback)
--     end
--   elseif data.requestType == "POST" then
--     if data.view == "submitPost" then
--       self:SUBMIT(data.requestType, data, _callback)
--     end
--   elseif  data.requestType == "VOTE" then
--     if data.view == "updateVotes" then
--       self:UpdateVotes(data, _callback)
--     end
--   end
-- end

-- use this later:
-- function Coronium:SUBMIT( uri, data, _callback)
--   print ('****** djangoAPI Submit ******')
--   for k,v in pairs(data) do
--     print (k, ' ', v)
--   end
--
--   local function r( event )
--       if ( event.isError ) then
--           print( "Network error: ", event.response )
--       elseif ( event.phase == "ended" ) then
--           print( "Bytes transferred: ", event.bytesTransferred )
--
--           print ( "Response:", event.response)
--       end
--   end
--
--   -- Post Data
--   local user = 1 --fbData.userData.userID, --"10102097157890742", -- Test FB ID (Jeremiah's FB ID)
--   local title = data.title
--   local client_id = data.client_id
--   local option_a = data.option_a
--   local image_a_name = "image_a"
--   local image_a = data.image_a
--   local image_a_filepath = system.pathForFile( image_a, self.dir )
--   local option_b = data.option_b
--   local image_b_name = "image_b"
--   local image_b = data.image_b
--   local image_b_filepath = system.pathForFile( data.image_b, self.dir )
--
--
--   local multipart = MultipartFormData.new()
--   multipart:addField("user",user)
--   multipart:addField("title",title)
--   multipart:addField("client_id",client_id)
--   multipart:addField("option_a",option_a)
--   multipart:addField("option_b",option_b)
--   multipart:addFile(  "image_a",
--                       system.pathForFile( data.image_a, system.TemporaryDirectory ),
--                       "image/jpeg",
--                       data.image_a
--                     )
--   multipart:addFile(  "image_b",
--                       system.pathForFile( data.image_b, system.TemporaryDirectory ),
--                       "image/jpeg",
--                       data.image_b
--                     )
--   --TODO tidy up addFile
--   -- multipart:addFile(  image_a,
--   --                     image_a_filepath,
--   --                     self.JPG,
--   --                     image_a
--   --                   )
--   -- multipart:addFile(  image_b,
--   --                     image_b_filepath,
--   --                     self.JPG,
--   --                     image_b
--   --                   )
--
--   multipart:addHeader("username", "skypopcorn1") -- TODO dynamically add token rather than un/p
--   multipart:addHeader("password", "Osurfc-99")
--   local params = {}
--   params.body = multipart:getBody() -- Must call getBody() first!
--   params.headers = multipart:getHeaders() -- Headers not valid until getBody() is called.
--
--
--   network.request( self.POST_ENDPOINT, "POST", r, params)
--
-- end
-- function Coronium:CheckVoteStatus(data, _callback)
--   local post_id = tostring(data.post_id)
--   local user_id = tostring(data.user_id)
--   local q = "?post_id="..post_id.."&user_id="..user_id
--   local uri = self.VOTE_CHECK .. q
--   network.request( uri, data.requestType, _callback)
-- end

--
-- function Coronium:UpdateVotes(data, _callback)
--   print ('updating votes')
--   local request_method
--
--   if data.voteType == 'UPDATE' then
--       request_method = "PUT"
--       local post_id = tostring(data.post_id)
--       local user_id = tostring(data.user_id)
--
--       local body = {
--         post = data.post_id,
--         user = data.user_id,
--         vote_index = data.voteItemIndex,
--       }
--       body = json.encode(body)
--
--       local params = {}
--         params.headers = {}
--         params.headers["Content-Type"] = "application/json"
--
--         params.body = body
--
--       local q = post_id.."/?user="..user_id
--       local uri = self.VOTE_UPDATE .. q
--       network.request( uri, request_method, _callback, params)
--     elseif data.voteType == 'REMOVE' then
--
--       -- REMOVE
--       print('remove vote')
--     elseif data.voteType == 'INSERT' then
--       -- ADD
--       request_method = "POST"
--       local post_id = tostring(data.post_id)
--       local user_id = tostring(data.user_id)
--
--       local body = {
--         post = data.post_id,
--         user = data.user_id,
--         vote_index = data.voteItemIndex,
--       }
--       body = json.encode(body)
--       print ('json body', body)
--       local params = {}
--         params.headers = {}
--         params.headers["Content-Type"] = "application/json"
--
--         params.body = body
--
--       local uri = self.VOTE_ADD
--       network.request( uri, request_method, _callback, params)
--       print('add vote')
--     end
--
--
-- end
