using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Network;

using SkillBridge.Message;
using Services;

public class testt : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
        Debug.Log("ConnectToServer() Start ");
        //NetClient.Instance.CryptKey = this.SessionId;
        NetClient.Instance.Init("127.0.0.1", 8000);
        NetClient.Instance.Connect();
        UserService.Instance.OnTest = OnTest;
        SendTest();
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void SendTest()
    {

        NetMessage message = new NetMessage();
        message.Request = new NetMessageRequest();
        message.Request.hollowWorld = new TestRequest();
        message.Request.hollowWorld.hollowWorld = "hollowWorld";
        Debug.LogFormat("Test:{0}", message.Request.hollowWorld.hollowWorld);
        NetClient.Instance.SendMessage(message);

    }

    void OnTest(string message)
    {
        Debug.LogFormat("Test:{0}", message);
    }
}
