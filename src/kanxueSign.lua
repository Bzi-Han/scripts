local state = {}

function getTaskDomain()
    return 'bbs.pediy.com'
end

-- return a json string of the function list
function getTaskFunctionList()
    return [[
        {
            "sign": "签到"
        }
    ]]
end

function setTaskPassport(passport)
    state.passport = passport
end

function sign()
    --获取UID
    local url = 'https://bbs.pediy.com/'
    local headers = {
        ["Cookie"] = state.passport
    }
    
    local result = requests.get(url, headers)
    if 200 == result.code then
        local uid = string.match(result.content, "uid = '(%d+)'")

        if '0' ~= uid then
            --获取CSRF_TOKEN
            url = 'https://bbs.pediy.com/user-tasks-909048-1.htm'

            result = requests.get(url, headers)
            if 200 == result.code then
                local csrf_token = string.match(result.content, 'content="([a-f0-9]+)"')
                
                --签到
                url = 'https://bbs.pediy.com/user-signin.htm'
                headers = {
                    ['Cookie'] = state.passport,
                    ['X-Requested-With'] = 'XMLHttpRequest',
                }

                result = requests.post(url, 'csrf_token=' .. csrf_token, headers)

                logger.info(result.content)

                return 200 == result.code
            end
        end
    end

    return false
end