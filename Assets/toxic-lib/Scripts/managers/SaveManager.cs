using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
public class SaveManager : MonoBehaviour
{
    [System.Serializable]
    public struct SaveData
    {
        public string scene;
        public int SavePoint;
    }

    public string currentScene;
    public int SavePoint;
    public SaveData saveData;
    public List<bool> aniListBool;

    public List<SavePoint> savePoints;
    

    void Start()
    {
        ResetSavePoints();
    }
    public void TemporarySave()
    {
        this.saveData.scene = currentScene;
        this.saveData.SavePoint = SavePoint;
    }

    public void SaveCall()
    {
        BinaryFormatter bf = new BinaryFormatter();
        FileStream fs = File.Create(Application.dataPath + "/SaveFile.soda");

        bf.Serialize(fs, this.saveData);
        fs.Close();
    }

    public void LoadCall()
    {
        BinaryFormatter bf = new BinaryFormatter();
        FileStream fs = File.Open(Application.dataPath + "/SaveFile.soda", FileMode.Open);

        if(fs != null & fs.Length >0)
        {
            this.saveData = (SaveData)bf.Deserialize(fs);
            this.currentScene = this.saveData.scene;
            this.SavePoint = this.saveData.SavePoint;
        }
        else
        {
            Debug.Log("세이브 파일이 없다요");
        }
    }

    public void ApplySaveData()
    {
        if(SceneManager.GetActiveScene().name == currentScene)
        {
            if (savePoints.Count != 0)
            {
                for (int i = SavePoint; i < 0; i--)
                {
                    savePoints[i].ApplyLoad();
                }
            }
        }
        else
        {
            
        }
    }

    public void ResetSavePoints()
    {
        savePoints.Clear();
        foreach (var a in GameObject.FindObjectsOfType<SavePoint>())
        {
            savePoints.Add(a);
        }

        savePoints.Sort(delegate (SavePoint A, SavePoint B)
        {
            if (A.SavePointNum > B.SavePointNum) return 1;
            else if (A.SavePointNum < B.SavePointNum) return -1;
            return 0;
        });
    }

    public void Update()
    {
        if(Input.GetKeyDown(KeyCode.F1))
        {
            game_manager.instance.player.transform.position = savePoints[0].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F2))
        {
            game_manager.instance.player.transform.position = savePoints[1].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F3))
        {
            game_manager.instance.player.transform.position = savePoints[2].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F4))
        {
            game_manager.instance.player.transform.position = savePoints[3].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F5))
        {
            game_manager.instance.player.transform.position = savePoints[4].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F6))
        {
            game_manager.instance.player.transform.position = savePoints[5].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F7))
        {
            game_manager.instance.player.transform.position = savePoints[6].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F8))
        {
            game_manager.instance.player.transform.position = savePoints[7].transform.position;
        }
        else if(Input.GetKeyDown(KeyCode.F9))
        {
            game_manager.instance.player.transform.position = savePoints[8].transform.position;
        }
    }

}
