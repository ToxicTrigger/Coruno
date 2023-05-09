using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WWISE : MonoBehaviour
{
    public string sound;
    bool dont;

    public void PlaySound(string name)
    {
        if((this.transform.CompareTag("Player") && !this.transform.parent.GetComponent<player>().isShilouette))
        AkSoundEngine.PostEvent(name, this.gameObject);
    }

    public void PlaySoundOther(string name)
    {
            AkSoundEngine.PostEvent(name, this.gameObject);
    }

    public static void PlaySoundOther_s(string name, GameObject obj)
    {
        AkSoundEngine.PostEvent(name, obj);
    }

    public static void PlaySounds(player me, GameObject target ,string name)
    {
        if(!me.isShilouette)
        AkSoundEngine.PostEvent(name, target);
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if(other.CompareTag("Player") && !dont)
        {
            AkSoundEngine.PostEvent(sound, this.gameObject);
            dont = true;
        }    
    }
}
