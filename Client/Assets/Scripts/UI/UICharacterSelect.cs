using Models;
using Services;
using SkillBridge.Message;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UICharacterSelect : MonoBehaviour {

    public List<UIPlayCharcter> uiPlayCharcter = new List<UIPlayCharcter>();
    public List<GameObject> uiChar = new List<GameObject>();
    public ToggleGroup characterSelectToggle;

    // Use this for initialization
    void Start () {
        InitCharacterSelect();
        UserService.Instance.OnCharacterCreate = OnCharacterCreate;
        
    }

    public void InitCharacterSelect()
    {
        foreach(UIPlayCharcter var in uiPlayCharcter)
        {
            var.gameObject.SetActive(false);
        }

        for (int i = 0; i < User.Instance.Info.Player.Characters.Count; i++)
        {
            uiPlayCharcter[i].gameObject.SetActive(true);
            uiPlayCharcter[i].profilePicture.gameObject.SetActive(true);
            uiPlayCharcter[i].addCharcterButton.gameObject.SetActive(false);
            uiPlayCharcter[i].Name.text = DataManager.Instance.Characters[i + 1].Name;
            uiPlayCharcter[i].level.text = "0";
        }

        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].gameObject.SetActive(true);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].profilePicture.gameObject.SetActive(false);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].toggle.gameObject.SetActive(false);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].addCharcterButton.gameObject.SetActive(true);
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].Name.text = "创建新角色";
        uiPlayCharcter[User.Instance.Info.Player.Characters.Count].level.text = "";

        OnSelectCharacter(0);

    }

    private void OnSelectCharacter(int i)
    {


        foreach (GameObject Char in uiChar)
        {

            Char.SetActive(false);
        }
        uiChar[i].gameObject.SetActive(true);

    }

    void OnCharacterCreate(Result result, string message)
    {
        if (result == Result.Success)
        {
            InitCharacterSelect();

        }
        else
            MessageBox.Show(message, "错误", MessageBoxType.Error);
    }
}
