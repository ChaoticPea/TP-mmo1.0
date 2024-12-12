using Models;
using Services;
using SkillBridge.Message;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UICharacterCreate : MonoBehaviour {

    public List<Button> uiProfessionButton = new List<Button>();
    public List<Image> uiProfessionImage = new List<Image>();
    public List<GameObject> uiChar = new List<GameObject>();


    public Text description;
    public InputField charName;

    private CharacterClass charClass;

    // Use this for initialization
    void Start () {
        InitCharacterCreate();
        DataManager.Instance.Load();
    }

    public void InitCharacterCreate()
    {

        for (int i = 0; i < uiProfessionButton.Count; i++)
        {
            int idx = i;
            uiProfessionButton[i].onClick.AddListener(() => 
            {
                OnSelectProfession(idx);
            });
        } 

        
    }

    private void OnSelectProfession(int i)
    {

        charClass = (CharacterClass)i+1;
        foreach (GameObject Char in uiChar)
        {

            Char.SetActive(false);
        }
        uiChar[i].gameObject.SetActive(true);

        foreach (Image ProfessionImage in uiProfessionImage)
        {
            ProfessionImage.gameObject.SetActive(false);
        }
        uiProfessionImage[i].gameObject.SetActive(true);


        description.text = DataManager.Instance.Characters[i+1].Description;

    }

    public void OnClickCreate()
    {
        if (string.IsNullOrEmpty(this.charName.text))
        {
            MessageBox.Show("请输入角色名称");
            return;
        }

        UserService.Instance.SendCharacterCreate(this.charName.text, this.charClass);
    }
}
