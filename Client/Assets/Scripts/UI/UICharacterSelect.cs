using Models;
using Services;
using SkillBridge.Message;
using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class UICharacterSelect : MonoBehaviour {

    public List<UIPlayCharcter> uiPlayCharcter = new();
    public List<GameObject> uiChar = new();
    public ToggleGroup characterSelectToggle;
    public bool isHaveChar=false;
    public byte selectCharacterIdx = 0;

    // Use this for initialization
    void Start () {

        InitCharacterSelect();

    }

    public void InitCharacterSelect()
    {
        foreach(UIPlayCharcter var in uiPlayCharcter)
        {
            var.toggle.isOn = false;
            var.gameObject.SetActive(false);
        }

        for (byte i = 0; i < User.Instance.Info.Player.Characters.Count; i++)
        {
            isHaveChar=true;
            uiPlayCharcter[i].gameObject.SetActive(true);
            uiPlayCharcter[i].profilePicture.gameObject.SetActive(true);
            uiPlayCharcter[i].toggle.gameObject.SetActive(true);
            uiPlayCharcter[i].addCharcterButton.gameObject.SetActive(false);
            uiPlayCharcter[i].Name.text = User.Instance.Info.Player.Characters[i].Name;
            uiPlayCharcter[i].Class = User.Instance.Info.Player.Characters[i].Class;
            uiPlayCharcter[i].level.text = User.Instance.Info.Player.Characters[i].Level.ToString();
        }

        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].gameObject.SetActive(true);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].profilePicture.gameObject.SetActive(false);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].toggle.gameObject.SetActive(false);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].addCharcterButton.gameObject.SetActive(true);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].Name.text = "创建新角色";
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].Class = CharacterClass.Warrior;
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].level.text = "";

        for (byte i = 0; i < uiChar.Count; i++)
        {
            
            if (i == (byte)uiPlayCharcter[0].Class-1)
            {
                uiChar[i].SetActive(true);
            }
            else
            {
                uiChar[i].SetActive(false);
            }

        }

    }

    public void SelectCharacter()
    {
        for (byte v = 0; v < uiPlayCharcter.Count; v++)
        {
            if (uiPlayCharcter[v].toggle.isOn == true)
            {
                selectCharacterIdx = v ;
                for (byte i = 0; i < uiChar.Count; i++)
                {

                    if (i == (byte)uiPlayCharcter[v].Class-1)
                    {
                        uiChar[i].SetActive(true);
                    }
                    else
                    {
                        uiChar[i].SetActive(false);
                    }
                }
            }
            
        }

    }

    public void OnClickBegin()
    {
        if (isHaveChar)
        {
            UserService.Instance.SendGameEnter(selectCharacterIdx);
        }
        else
        {
            uiPlayCharcter[0].addCharcterButton.onClick.Invoke();
        }
    }

    public void OnClickBack()
    {
        SceneManager.Instance.LoadScene("Loading");
    }


}
