local launchArgs = ...

local json = require("json")
local mime = require("mime")
local commands_json,signInText,usernameText,passwordText,emailText,usernameTxtBox,passwordTxtBox,emailTxtBox,doneButton,pickerWheel,msg,title,takePicButton,uploadButton,saveButton,selectFlavorButton
local widget = require( "widget" )
local inspect = require("inspect")

local x,y = display.contentCenterX, display.contentCenterY
local w = display.viewableContentWidth
local h = display.viewableContentHeight



APPID = ''
RESTAPIKEY = ''

parse = require( "mod_parse" )
parse:init( { appId = APPID, apiKey = RESTAPIKEY } )


local function displayFeatured(dessert,friendsNum)

    usernameText:removeSelf()
    usernameText = nil
    signInText:removeSelf()
    signInText = nil
    passwordText:removeSelf()
    passwordText = nil
    emailText:removeSelf()
    emailText = nil
    usernameTxtBox:removeSelf()
    usernameTxtBox = nil
    passwordTxtBox:removeSelf()
    passwordTxtBox = nil
    emailTxtBox:removeSelf()
    emailTxtBox = nil
    saveButton:removeSelf()
    saveButton = nil
    selectFlavorButton:removeSelf()
    selectFlavorButton = nil
    
    local cupcakeText = display.newText("Welcome to the Dessert-O-Meter!\nThe cupcake of the day is "..dessert..". Guess what, "..friendsNum.." other members like "..dessert.." too!", x,y, 300, 400, "GillSans", 15 )
    local cupcakeImage = display.newImage( "images/"..dessert..".png" )
    cupcakeImage.x = display.contentWidth/2
    cupcakeImage.y = display.contentHeight/2
   

    local onComplete = function(event)
    local photo = event.target

    local photoGroup = display.newGroup()  
    photoGroup:insert(photo)

    local tmpDirectory = system.TemporaryDirectory
    display.save(photoGroup, "photo.jpg", tmpDirectory) 

        --clear
        display.remove(cupcakeImage)
        cupcakeImage = nil
        display.remove(cupcakeText)
        cupcakeText = nil
        display.remove(saveButton)
        saveButton = nil
        display.remove(takePicButton)
        takePicButton = nil


        photo.x = display.contentWidth/2
        photo.y = display.contentWidth/2

        local function onUploadButtonRelease(event)
            --upload the pic
            local function callbackFunction(event)
                
                    local response = event.response
                    print(inspect(response))
                    
                    if event.error ~= nil then
                        title = "Oops!"
                        msg = event.error
                    else
                        --alert thanks
                        local alert = native.showAlert( "Thanks!", "Your picture will be added to our gallery!", {"OK"}, onComplete )

                    end
               
            end

    parse:uploadFile( { ["filename"] = "photo.jpg", ["baseDir"] = system.TemporaryDirectory }, callbackFunction )

    end

        --add a button to allow upload
        uploadButton = widget.newButton
        {
            label = "Upload your photo",
            id = "btnPhoto",
            width=200,
            height=40,
            labelColor = {
                  default = { 1 },
                  over = { .675, .224, .675 },
                },
            defaultFile = "images/button.png",
            overFile = "images/button_on.png",
            onRelease = onUploadButtonRelease,
            font = "GillSans"

        }
        uploadButton.x = display.contentWidth/2
        uploadButton.y = display.contentHeight-50



    end

    local onTakePicButtonRelease = function(event)
        media.show( media.Camera, onComplete )
    end

    takePicButton = widget.newButton
        {
            label = "Take a picture of your favorite dessert!",
            id = "btnPic",
            width=display.contentWidth-40,
            height=40,
            labelColor = {
                  default = { 1 },
                  over = { .675, .224, .675 },
                },
            defaultFile = "images/button.png",
            overFile = "images/button_on.png",            
            onRelease = onTakePicButtonRelease,
            font = "GillSans"

        }
        takePicButton.x = display.contentWidth/2
        takePicButton.y = display.contentHeight/2+200



end

local function init()

    
    local bg = display.newRoundedRect( x,y, display.contentWidth,display.contentHeight,3)
    bg:setFillColor(.60,.40,.80)--amethyst
    bg.strokeWidth=10
    bg:setStrokeColor(.451, .224, .675)--wysteria


    --create login

    local function onReturn( event )
    -- Hide keyboard when the user clicks "Return" in this field
        if ( "submitted" == event.phase ) then
            native.setKeyboardFocus( nil )
        end
    end

    signInText = display.newText("Register for the Dessert-O-Meter!", x,y, 300, 400, "GillSans", 20 )
    
    usernameText = display.newText("Username:", x,y+40, 300, 400, "GillSans", 20)
    
    usernameTxtBox = native.newTextField( x+40,signInText.y-140, 200, 20, onReturn)
    
    passwordText = display.newText("Password:", x,y+70, 300, 400, "GillSans", 20)
    
    passwordTxtBox = native.newTextField( x+40,usernameTxtBox.y+30, 200, 20, onReturn)
    
    passwordTxtBox.isSecure=true
    
    emailText = display.newText("Email:", x,y+100, 300, 400, "GillSans", 20 )
    
    emailTxtBox = native.newTextField( x+40,passwordTxtBox.y+30, 200, 20, onReturn)
    
    

    local function onSelectFlavorButtonRelease()

        local columnData = 
        { 
            { 
                align = "center",
                width = display.contentWidth,
                startIndex = 1,
                labels = 
                {
                    "","chocolate", "watermelon", "rainbow"
                },
            }
        }

       pickerWheel = widget.newPickerWheel
        {
            top = display.contentHeight-220,
            font = native.systemFontBold,
            columns = columnData
        }

        local function onDoneButtonRelease(event)

            if event.phase == "ended" then

                local pickerValues = pickerWheel:getValues()
                flavorIndex = pickerValues[1].value

                
                    display.remove( pickerWheel )
                    pickerWheel = nil
                       
                    display.remove( doneButton )
                    doneButton = nil

            end

        end

        doneButton = widget.newButton
            {
                defaultFile = "images/btnClose.png",
                overFile="images/btnClose.png",
                onRelease = onDoneButtonRelease,
                width=29,
                height=17,
                font = "GillSans",
                labelColor = {
                  default = { 1 },
                  over = { .675, .224, .675 },
                }

            }
    
            doneButton.x = display.contentWidth/2
            doneButton.y = display.contentHeight-200
        end


       selectFlavorButton = widget.newButton
        {
            label = "My Favorite Flavor",
            id = "btnSelectFlavor",
            width = 170,
            height = 40,
            defaultFile = "images/button.png",
            overFile = "images/button_on.png",
            onRelease = onSelectFlavorButtonRelease,
            font = "GillSans",
            labelColor = {
                  default = { 1 },
                  over = { .675, .224, .675 },
                }

        }
        selectFlavorButton.x = display.contentWidth/2
        selectFlavorButton.y = display.contentHeight/2

     local function emailClient(email)
        
        local function emailSent(event)
            if event.phase == "ended" then
                local response = event.response
                print(response)
            end
        end
        
        
        local userData = { ["email"] = email }
        
        parse:run( "sendEmail",userData,emailSent )

       
    end


    local function onSaveButtonRelease()

        print(usernameTxtBox.text,passwordTxtBox.text,emailTxtBox.text,flavorIndex)

        --register new user

        local function registerNewUser(event)
            
            print(flavorIndex)

            if flavorIndex ~= nil then
                
            
                local response = event.response
                print(inspect(event.response))
                
                print("this user's fave is "..flavorIndex)
                registerParseDevice(deviceToken,flavorIndex)
                --pass this over to Parse as a channel and while you're at it, do the installation

                if event.error ~= nil then
                    title = "Oops!"
                    msg = event.error
                else
                    title = "Success!"
                    msg = "You're now a registered user of the Dessert-O-Meter!"
                
                    --get featured dessert
                    local function getFeatured(event)

                          
                            local response = event.response
                            local dessert = response.result

                            print(inspect(dessert))
                            --if dessert is a table
                            if dessert[1] == nil then
                                d=dessert 
                            else 
                                d=dessert[1].favorite
                            end

                            emailClient(emailTxtBox.text)
                            displayFeatured(d,#response)
              
                    end
   
                    
                local params = {
                            [""] = ""
                         }
                    
                    parse:run( "getFeatured",params,getFeatured )
                end
                
                local alert = native.showAlert( "", msg, {"OK"}, onComplete )
            
            else
                --they forgot the flavor picker
                local alert = native.showAlert( "Oops", "Please pick a favorite flavor", {"OK"}, breakProcess )


            end
          
        end
            
            
    local userData =
        {
            ["email"] = emailTxtBox.text,
            ["password"] = passwordTxtBox.text,
            ["username"] = usernameTxtBox.text,
            ["favorite"] = flavorIndex

        } 

        print("create the user")
    parse:createUser(userData,registerNewUser)

    end
  
 
     saveButton = widget.newButton
        {
            label = "Save",
            id = "btnSave",
            width=80,
            height=40,
            defaultFile = "images/button.png",
            overFile = "images/button_on.png",            
            onRelease = onSaveButtonRelease,
            font = "GillSans",
            labelColor = {
                  default = { 1 },
                  over = { .675, .224, .675 },
                }

        }
        saveButton.x = display.contentWidth/2
        saveButton.y = display.contentHeight/2+50


        
    end 

function registerParseDevice(deviceToken,flavorIndex)
   
      local function parseNetworkListener(event)
        print(event.response)
      end

        --[[headers = {}
        headers["X-Parse-Application-Id"] = APPID
        headers["X-Parse-REST-API-Key"] = RESTAPIKEY
        headers["Content-Type"] = "application/json"
 
        commands_json =
            {
             ["deviceType"] = "ios",
             ["deviceToken"] = deviceToken,
             ["channels"] = {flavorIndex}            
            }        
 
        postData = json.encode(commands_json)
        
        data = ""
        local params = {}
        params.headers = headers
        params.body = postData
        network.request( "https://api.parse.com/1/installations" ,"POST", parseNetworkListener,  params)
        ]]

        local installationData = { ["deviceType"] = "ios",
             ["deviceToken"] = deviceToken,
             ["channels"] = {flavorIndex} 
        }
        
        parse:createInstallation( installationData,parseNetworkListener )

end

local function onNotification( event )

   print("my device id is",event.token)
    
    if event.type == "remoteRegistration" then
        
        if event.token ~= nil then

            --save the deviceToken as a global so we can grab it later
            deviceToken = event.token
            
        else
            print("no token returned, too bad")
        end
        
    elseif event.type == "remote" then
        native.showAlert( "Dessert-O-Meter", event.alert , { "OK" } )
   end

end

local notificationListener = function( event )
   native.setProperty( "applicationIconBadgeNumber", 0 )
end


Runtime:addEventListener( "notification", onNotification )

init()



