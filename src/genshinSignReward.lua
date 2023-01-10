local mihoyo = {
    ['charpool'] = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
    ['salt'] = 'YVEIkzDFNHLeKXLxzqCA9TzxCpWwbIbk',
    ['signDataFormat'] = 'salt=%s&t=%d&r=%s',
    ['DSDataFormat'] = '%s,%s,%s',
}

function mihoyo:resetRandomSeed(seed)
    seed = seed or os.time()

    math.randomseed(seed)

    return seed
end

function mihoyo:randomString(n)
    local result = ''

    for i = 1, n do
        result = result .. string.char(string.byte(self['charpool'], math.random(1, string.len(self['charpool']))))
    end
    
    return result
end

function mihoyo:getRandomDeviceID()
    self:resetRandomSeed()
    
    return string.lower(string.format(
        '%s-%s-%s-%s-%s',
        self:randomString(8),
        self:randomString(4),
        self:randomString(4),
        self:randomString(4),
        self:randomString(12)
    ))
end

function mihoyo:getDS()
    local timestamp = self:resetRandomSeed()
    local randomString = self:randomString(6)
    local signData = string.format(self['signDataFormat'], self['salt'], timestamp, randomString)
    local sign = string.lower(crypto.md5(signData))

    return string.format(self['DSDataFormat'], timestamp, randomString, sign)
end

local state = {}

function getTaskDomain()
    return 'api-takumi.mihoyo.com'
end

-- return a json string of the function list
function getTaskFunctionList()
    return [[
        {
            "sign": "每日签到"
        }
    ]]
end

function setTaskPassport(passport)
    state.data, state.passport = string.gmatch(passport, '(.+)%$(.+)')()
end

function sign()
    if '' == state.data or '' == state.passport then
        logger.failed('请正确配置通行证数据')
        return false
    end

    local url = 'https://api-takumi.mihoyo.com/event/bbs_sign_reward/sign'
    local headers = {
        ['Cookie'] = state.passport,
        ['User-Agent'] = 'Mozilla/5.0 (Linux; Android 12; M2012K10C Build/SP1A.210812.016; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/95.0.4638.74 Mobile Safari/537.36 miHoYoBBS/2.36.1',
        ['Content-Type'] = 'application/json',
        ['Origin'] = 'https://webstatic.mihoyo.com',
        ['X-Requested-With'] = 'com.mihoyo.hyperion',
        ['Referer'] = 'https://webstatic.mihoyo.com/',
        ['DS'] = mihoyo:getDS(),
        ['x-rpc-app_version'] = '2.36.1',
        ['x-rpc-device_id'] = '5u51xwrs-ucll-lzay-d7o0-85l7tyosr0mi',
        ['x-rpc-client_type'] = 5
    }
    local data = state.data

    local result = requests.post(url, data, headers)
    if result.success and 200 == result.code then
        result = json.loads(result.content)
        if 0 == result.retcode then
            logger.succeed(result.message)
            return true
        else
            logger.failed(result.message)
            return false
        end
    else
        logger.failed(result.errorMessage, result.content)
    end

    return false
end