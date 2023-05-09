using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sound_manager : MonoBehaviour
{
    int bgm_shuffle;
    public List<string> bgm_list;
    public Transform Start, End;
    public float x, dist;
    player player;

    private void Awake() 
    {
        //StartCoroutine(Play());
        dist = Vector3.Distance(Start.position, End.position);
        AkSoundEngine.PostEvent("Play_BGM", this.gameObject);
    }

    private void Update()
    {
        if(player == null)
        {
            player = game_manager.instance.localPlayer.GetComponent<player>();
        }
        {
            x = Mathf.Clamp((player.transform.position.x / dist ) * 100, 0, 100);    
            AkSoundEngine.SetRTPCValue("BGM", x, this.gameObject, 1500);
        }
    }

    public IEnumerator Play()
    {
        while(true)
        {
            bgm_shuffle = Random.Range(0, bgm_list.Count - 1);
            AkSoundEngine.PostEvent(bgm_list[bgm_shuffle], this.gameObject);
            yield return new WaitForSeconds(60 * 5);
        }
    }
}
