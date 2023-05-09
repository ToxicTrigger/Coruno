using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SwapTimer : MonoBehaviour
{
    player player;
    List<Image> Images;
    Image Up;
    void Start()
    {
        Images = new List<Image>();
        var im = GetComponentsInChildren<Image>();
        foreach (var item in im)
        {
            Images.Add(item);
            if(item.name.Equals("SwapTimerUp")) Up = item;
        }
    }

    void Update()
    {
        if (player == null)
        {
            player = game_manager.instance.localPlayer.GetComponent<player>();
        }
        else
        {
            if (game_manager.instance.flags.flags["Swaped"])
            {
                var a = Images[0].color;
                a.a = Mathf.Lerp(a.a, 1, Time.fixedDeltaTime * 3);
                foreach (var item in Images)
                {
                    item.color = a;
                }
                Up.fillAmount = 1-player.GetComponent<Swap>().SwapLife;
            }
            else
            {
                var a = Images[0].color;
                a.a = Mathf.Lerp(a.a, 0, Time.fixedDeltaTime * 3);
                foreach (var item in Images)
                {
                    item.color = a;
                }
                Up.fillAmount = 1;
            }
        }
    }
}
