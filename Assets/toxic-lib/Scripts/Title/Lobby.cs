using UnityEngine;
using Photon.Pun;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;

public class Lobby : MonoBehaviourPunCallbacks
{
    public bool isMaster;
    public GameObject pressAnyKey;
    public string SceneName;
    bool InButtonTitle;
    bool startTw;
    AsyncOperation load;
    bool hasIntroDone;
    public int slice;
    public List<Image> imgs;

    public GameObject intro_root;
    private void Start()
    {
        DontDestroyOnLoad(this);
        load = SceneManager.LoadSceneAsync(SceneName);
        load.allowSceneActivation = false;
    }


    public void remove( GameObject target )
    {
        (target).SetActive(false);
        slice ++;
    }

    IEnumerator Popup()
    {
        var images = intro_root.GetComponentsInChildren<Image>();
        while(!images[0].color.a.AlmostEquals(1.0f, 0.001f))
        {
            foreach(var i in images)
            {
                var color = i.color;
                color.a += Time.deltaTime;
                i.color = color;
            }
            yield return new WaitForEndOfFrame();
        }
    }

    private void Update()
    {
        if (load.progress.AlmostEquals(0.9f, 0.001f))
        {
            if (Input.anyKey && slice == 6)
            {
                InButtonTitle = true;
                StopAllCoroutines();
                load.allowSceneActivation = true;
            }
            else if(slice == 0 && Input.anyKey)
            {
                intro_root.SetActive(true);
                slice ++ ;
                StartCoroutine(Popup());
            }
            else if(Input.anyKeyDown)
            {
                imgs[slice].gameObject.SetActive(false);
                slice ++;
                imgs[slice].gameObject.SetActive(true);
            }

            if(!startTw)
            {
                StartCoroutine(Twinkling(pressAnyKey));
                startTw = true;
            }
        }
    }

    IEnumerator Twinkling(GameObject obj)
    {
        obj.SetActive(true);
        while (!InButtonTitle)
        {
            while (!InButtonTitle)
            {
                var image = obj.GetComponent<Image>();
                Color tem = image.color;
                tem.a += 0.05f;
                image.color = tem;
                if (tem.a >= 1)
                {
                    break;
                }
                yield return new WaitForSeconds(0.05f);
            }
            while (!InButtonTitle)
            {
                var image = obj.GetComponent<Image>();
                Color tem = image.color;
                tem.a -= 0.05f;
                image.color = tem;

                if (tem.a <= 0)
                {
                    break;
                }
                yield return new WaitForSeconds(0.05f);
            }
            yield return null;
        }
    }
}