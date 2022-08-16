local state = {}

function getTaskDomain()
    return 'tieba.baidu.com'
end

-- return a json string of the function list
function getTaskFunctionList()
    return [[
        {
            "signAll": "签到所有关注贴吧"
        }
    ]]
end

function setTaskPassport(passport)
    state.passport = passport
end

function signAll()
    local url = "http://tieba.baidu.com/f/like/mylike"
    local headers = {
        ["Cookie"] = state.passport
    }

    local result = requests.get(url, headers)
    logger.info(result.code, result.content)
    if 200 == result.code then
        url = 'https://tieba.baidu.com/sign/add'

        for name in string.gmatch(result.content, 'title="([\35-\255]+)">') do
            local signResult = requests.post(url, 'ie=utf-8&kw=' .. crypto.urlEncode(name), headers)

            logger.info('签到贴吧', name, signResult.content)
        end
    end

    return true
end