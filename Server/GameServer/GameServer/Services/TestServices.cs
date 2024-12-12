using NetCommon;
using Network;
using SkillBridge.Message;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace GameServer.Services
{
    class TestServices: Singleton<TestServices>
    {

        public void Init()
        {
            MessageDistributer<NetConnection<NetSession>>.Instance.Subscribe<TestRequest>(OnTest);
        }



        public void OnTest(NetConnection<NetSession> sender, TestRequest request)
        {
            
            sender.Session.Response.hollowWorld = new TestResponse();
            sender.Session.Response.hollowWorld.Welcome = "Welcome";
            sender.SendResponse();
            Log.InfoFormat("Success");
        }

    }
}
