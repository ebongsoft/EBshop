# -*- coding: utf-8 -*-
'''
@license: (C) Copyright 2019-2017, Node Supply TianWang WuLian Scientific Limited
@file: hello.py
@time: 2019/4/26 11:00
@author:LDC
@contact: 微信：1257309054@qq.com
'''
import hashlib

import requests

"""
后端请求接口流程：
1、向管理员要
  - 账号(account)
  - 密钥(key)
  - 服务器编号(num)

2、设置通知url
  - 调用【2.2】接口

3、获取token
  - 访问其他接口时需要使用token访问
  - 调用【2.3】接口

4、开启服务器
  - 开启远端服务器，接收机器连接上线请求
  - 调用【2.4.1】接口
5、监控前端用户扫码请求
6、获取机器状态
  - 调用【2.4.5】接口
  - link表示机器已经上线

7、返回机器状态给前端

8、用户付款，在微信异步回调中调用启动机器接口
  - 调用【2.4.6】接口
  - 服务器会自动发送机器启动指令

9、前端显示付款后页面
"""


def md5_encrypt(en_str):
    """
    使用md5二次加密生成32位的字符串
    :param en_str: 需要加密的字符串
    :return: 加密后的字符串
    """

    md5 = hashlib.md5()  # 使用MD5加密模式
    md5.update(en_str.encode('utf-8'))  # 将参数字符串传入

    return md5.hexdigest()


def set_inform_url():
    """
    设置通知url
    调用【2.2】接口
    key: 密钥,需要使用md5加密
    account: 账号
    clientDomain: 客户端域名
    linkInformUrl: 机器上线后，服务器通知客户端的url
    runInformUrl: 机器运行后，服务器通知客户端的url
    abnInformUrl: 机器出现异常后，服务器通知客户端的url

    设置成功，服务器会返回：{‘msg’: ‘success’,’code’: 1}
    设置失败，服务器会返回：{‘msg’: ‘failed’,’code’: 0,’remark’:’失败原因’}
    """

    url = "https://twwl.sailafeinav.com/shemachineapi/regiclientinfo/"
    data = {
        'key': md5_encrypt('12hdjdjd'),
        'account': 'test1',
        'clientDomain': "twwl.sailafeinav.com",
        'linkInformUrl': "https://twwl.sailafeinav.com/shemachineapi/linkinfo/",
        'runInformUrl': "https://twwl.sailafeinav.com/shemachineapi/runinfo/",
        'abnInformUrl': "https://twwl.sailafeinav.com/shemachineapi/abninfo/",
    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def get_token():
    """
    获取token
    - 访问其他接口时需要使用token访问
    - 调用【2.3】接口
    key: 密钥,需要使用md5加密
    account: 账号

    获取成功，服务器会返回：{"code":1,"token":"fac107b475396843e70ae0a1dd7d4007","msg":"success"}
    获取失败，服务器会返回：{"code":0,"remark":"用户不存在或者密钥检验出现有误","msg":"failed"}
    """
    url = "https://twwl.sailafeinav.com/shemachineapi/gettoken/"
    data = {
        'key': md5_encrypt('12hdjdjd'),
        'account': 'test1',

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def run_server():
    """
    开启服务器
    - 开启远端服务器，接收机器连接上线请求
    - 调用【2.4.1】接口

    返回会有延迟，可能会超过访问时间
    """
    url = "https://twwl.sailafeinav.com/shemachineapi/runserver/"
    data = {
        'token': 'ce1a0a7760152431d5b131057377160c',
        'account': 'test1',
        'num': 'server1'

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def close_server():
    """
    关闭服务器
    - 关闭远端服务器，拒绝机器连接上线请求
    - 调用【2.4.2】接口

    成功，服务器会返回：{"code":1,"remark":"服务器已经关闭","msg":"success"}
    失败，服务器会返回：{"code":0,"remark":"用户不存在或者密钥检验出现有误","msg":"failed"}
    """
    url = "https://twwl.sailafeinav.com/shemachineapi/closeserver/"
    data = {
        'token': 'ce1a0a7760152431d5b131057377160c',
        'account': 'test1',
        'num': 'server1'

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def get_machine_code():
    """
    获取机器编号
    - 调用【2.4.3】接口
    获取成功，服务器会返回示例：{"code":1,"counts":2,"details":["521","520"],"msg":"success"}
        details中的是机器编号
    获取失败，服务器会返回：{"code":0,"remark":"用户不存在获或者token已过期","msg":"failed"}
    """
    url = "https://twwl.sailafeinav.com/shemachineapi/getmachinenum/"
    data = {
        'token': 'ce1a0a7760152431d5b131057377160c',
        'account': 'test1',
        'num': 'server1'

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def get_all_machine_states():
    """
    获取所有机器状态
    - 调用【2.4.4】接口
    获取成功，服务器会返回示例：{"code":1,"link_counts":2,"details":{"run":[],"link":["521","520"]},"msg":"success","run_counts":0}
        details中的是机器编号
    获取失败，服务器会返回：{"code":0,"remark":"用户不存在获或者token已过期","msg":"failed"}
    """
    url = "https://twwl.sailafeinav.com/shemachineapi/states/"
    data = {
        'token': 'ce1a0a7760152431d5b131057377160c',
        'account': 'test1',
        'num': 'server1',
        'type': 'all'

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def get_one_machine_states(machine_code):
    """
    获取某台机器状态
    - 调用【2.4.5】接口
    :param machine_code: 机器编号

    获取成功，服务器会返回示例：{"code":1,"states":["link"],"msg":"success"}
       states中的是状态码
       状态码：
            “run”：机器正在运行
            “link”:机器已经上线
            “noreg”:机器编号不存在
            “error”:机器没有上线也没有运行
    获取失败，服务器会返回：{"code":0,"remark":"用户不存在获或者token已过期","msg":"failed"}
    """

    url = "https://twwl.sailafeinav.com/shemachineapi/states/"
    data = {
        'token': 'ce1a0a7760152431d5b131057377160c',
        'account': 'test1',
        'num': 'server1',
        'type': 'one',
        'code': machine_code

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def run_machine(machine_code, timer):
    """
    启动机器
    :param machine_code: 机器编号
    :param timer: 运行时长(分钟)，值不能超过1440
    启动成功，机器会返回：{"code":1,"msg":"success"}
    """

    url = "https://twwl.sailafeinav.com/shemachineapi/runmachine/"
    data = {
        'token': 'ce1a0a7760152431d5b131057377160c',
        'account': 'test1',
        'num': 'server1',
        'code': machine_code,
        'timer': timer

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


def restatr_machine(machine_code):
    """
    重启机器
    :param machine_code: 机器编号
    重启成功，机器会返回：{"code":1,"msg":"success"}
    """

    url = "https://twwl.sailafeinav.com/shemachineapi/runmachine/"
    data = {
        'token': 'ce1a0a7760152431d5b131057377160c',
        'account': 'test1',
        'num': 'server1',
        'code': machine_code,
        'timer': 0

    }
    response = requests.request('post', url, data=data)
    print(response.content.decode('utf-8'))


if __name__ == '__main__':
    # set_inform_url()
    # get_token()
    # run_server()
    # close_server()
    # get_machine_code()
    # get_all_machine_states()
    # get_one_machine_states(520)  # 520是机器编号
    # run_machine(520, 15)  # 给机器编号为520，启动15分钟
    # restatr_machine(520)  # 给机器编号为520，启动15分钟
    pass
