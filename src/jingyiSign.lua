local state = {}

function getTaskDomain()
    return 'bbs.125.la'
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
    local url = 'https://bbs.125.la/plugin.php?id=dsu_paulsign:sign'
    local headers = {
        ['Cookie'] = state.passport
    }

    local result = requests.get(url, headers)
    if 200 == result.code then
        local formhash = string.match(result.content, 'formhash" value="(%x+)"')

        if nil ~= formhash then
            local url = 'https://bbs.125.la/plugin.php?id=dsu_paulsign:sign&operation=qiandao&infloat=1'
            local data = 'formhash=' .. formhash .. '&submit=1&targerurl=&todaysay=&qdxq=kx'
            
            result = requests.post(url, data, headers)

            logger.info(result.code, result.content)
            
            return 200 == result.code
        end
    end

    return false
end