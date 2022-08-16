state = {}

def getTaskDomain():
    return 'music.163.com'

# return a json string of the def list
def getTaskdefList():
    return '''
        {
            "listen300": "自动听歌"
        }
    '''

def setTaskPassport(passport):
    state['passport'] = passport

# 听300首歌(每日上限300首)
def listen300():
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 Edg/81.0.416.72',
        'Cookie': state['passport']
    }
    data = {
        'params': '',
        'encSecKey': 'c8ad95f67079c3f34749858236b3a629da03729536a12ace6a173e44ad5b7184cd13f4d4a40e65320b74d7e3193a8306a9d6a962d89a8736eca9e1ffde1a3f1ada6bed84d957cde517b64b3ee6a0ea8f722c48fb416121f3f616a775327d1d19b2b717149d82ee72fab5171745d20b4c737514751b6513a017db5181a528d0a8'
    }

    # 获取私人FM推荐歌曲(每次访问获取的基本都是新的歌,每次3首)
    # count 获取次数(每次3首)
    url = 'http://interface.music.163.com/weapi/v1/radio/get'
    data['params'] = '3G7yZuXOSFjtwfm1G0%2BPxYAYcE1LOG4OS6IRCWfDqRI%3D'
    songs = {}
    i = 0
    while i < 150:
        result = requests.post(url, data, headers)
        if result['status'] == 200:
            result = json.loads(result['content'])
            result = result['data']
            for o in result:
                logger.info('解析:歌曲名字 => ' + o['name'])
                songs[str(int(o['id']))] = str(int(o['duration'] / 1000))
        i = i + 1

    url = 'https://music.163.com/weapi/feedback/weblog'
    # {0}: 歌曲id {1}:歌曲时长
    template = '{\\"action\\":\\"play\\",\\"json\\":{\\"type\\":\\"song\\",\\"wifi\\":0,\\"download\\":0,\\"id\\":{id},\\"time\\":{time},\\"end\\":\\"ui\\"}}'
    jsondata = '{"logs":"['
    for o in songs:
        jsondata = jsondata + \
            template.replace('{id}', o).replace('{time}', songs[o])+','
    jsondata = jsondata[0:len(jsondata) - 1]
    jsondata = jsondata+']"}'

    jsondata = crypto.aesEncrypt(
        jsondata, '0CoJUm6Qyw8W8jud', '0102030405060708', 'CBC', 'PKCS')
    data['params'] = crypto.aesEncrypt(
        jsondata, '4KID854PVcsYppIb', '0102030405060708', 'CBC', 'PKCS')

    result = requests.post(url, data, headers)
    logger.info(result.code, result.content)

    return True
