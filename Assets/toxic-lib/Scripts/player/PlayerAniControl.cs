using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAniControl : MonoBehaviour
{
    public MapObjectActivator mapObjectActivator;
    MapObjectManager mapObjectManager;
    player player;


    private void Start()
    {
        player = GetComponent<player>();
        mapObjectManager = game_manager.instance.mapObjectManager;
    }

    private void Update()
    {
        if (mapObjectManager.interActiveGameObject != null)
        {
            if (mapObjectManager.interActiveGameObject.gameObject.layer == LayerMask.NameToLayer("Box"))
            {
                if (player.haveBox)
                {
                    player.animator.SetInteger("Grab", 1);
                }
                else
                {
                    player.animator.SetInteger("Grab", 0);
                }

                if (mapObjectActivator.currentActivateObject != null)
                {
                    if ((int)game_manager.instance.dirPlayer == game_manager.instance.oriDir)
                    {
                        player.animator.SetInteger("Grab", 2);
                    }
                    else if (game_manager.instance.oriDir != 0)
                    {
                        player.animator.SetInteger("Grab", 3);
                    }
                    else
                    {
                        player.animator.SetInteger("Grab", 1);
                    }
                }
            }
            else if ((mapObjectManager.interActiveGameObject.gameObject.layer == LayerMask.NameToLayer("lever")))
            {   
                if (mapObjectActivator.currentActivateObject != null)
                {
                    if ((int)game_manager.instance.dirPlayer == game_manager.instance.oriDir)
                    {
                        player.animator.SetInteger("Grab", 5);
                    }
                    else if (game_manager.instance.oriDir != 0)
                    {
                        player.animator.SetInteger("Grab", 6);
                    }
                    else
                    {
                        player.animator.SetInteger("Grab", 4);
                    }
                }
                else
                {
                    player.animator.SetInteger("Grab", 0);
                }
            }
        }
        else
        {
            player.animator.SetInteger("Grab", 0);
        }
    }

}
