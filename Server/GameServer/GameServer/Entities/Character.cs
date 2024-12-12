using NetCommon;
using NetCommon.Data;
using NetCommon.Utils;
using GameServer.Core;
using Network;
using SkillBridge.Message;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GameServer.Entities
{
    /// <summary>
    /// Character
    /// 玩家角色类
    /// </summary>
    class Character : CharacterBase
    {
        public TCharacter Data;

        public double TeamUpdateTS;

        public double GuildUpdateTS;


        public Character(CharacterType type,TCharacter cha):
            base(new Core.Vector3Int(cha.MapPosX, cha.MapPosY, cha.MapPosZ),new Core.Vector3Int(100,0,0))
        {
            this.Data = cha;
            this.Id = cha.ID;
            this.Info = new NCharacterInfo();
            this.Info.Type = type;
            this.Info.Id = cha.ID;

            this.Info.Name = cha.Name;
            this.Info.Level = 10;//cha.Level;

            this.Info.Class = (CharacterClass)cha.Class;
            this.Info.mapId = cha.MapID;

        }


        /// <summary>
        /// 角色离开时调用
        /// </summary>


        public NCharacterInfo GetBasicInfo()
        {
            return new NCharacterInfo()
            {
                Id = this.Id,
                Name = this.Info.Name,
                Class = this.Info.Class,
                Level = this.Info.Level
            };
        }
    }
}
