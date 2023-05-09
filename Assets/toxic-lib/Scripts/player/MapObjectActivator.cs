using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapObjectActivator : MonoBehaviour
{
    MapObjectManager mapObjectManager;
    public GameObject currentActivateObject;
    player player;
    private void Start()
    {
        this.mapObjectManager = game_manager.instance.GetComponent<MapObjectManager>();
        this.player = game_manager.instance.localPlayer.GetComponent<player>();
    }

    private void OnTriggerStay2D(Collider2D collision)
    {
        if (player.photonView.IsMine || game_manager.instance.is_develop_mode)
        {
            if (collision.CompareTag("Interactive"))
            {
                if (collision.name.Contains("Ghost"))
                {
                    if (mapObjectManager.interActiveGameObject != collision.transform.parent.GetComponent<Priority>())
                    {
                        if (collision.transform.parent.GetComponent<Priority>() != null)
                            mapObjectManager.Add(collision.transform.parent.GetComponent<Priority>());
                    }
                    return;
                }

                if (mapObjectManager.interActiveGameObject != collision.GetComponent<Priority>())
                {
                    if (collision.gameObject.GetComponent<Priority>() != null)
                        mapObjectManager.Add(collision.gameObject.GetComponent<Priority>());
                }
            }
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (player.photonView.IsMine || game_manager.instance.is_develop_mode)
        {
            if (collision.CompareTag("Interactive"))
            {
                if (collision.name.Contains("Ghost"))
                {
                    if (collision.transform.parent.GetComponent<Priority>() != null)
                        mapObjectManager.Remove(collision.transform.parent.GetComponent<Priority>());
                    return;
                }

                if (collision.gameObject.GetComponent<Priority>() != null)
                    mapObjectManager.Remove(collision.gameObject.GetComponent<Priority>());
            }
        }
    }
    // Update is called once per frame
    void Update()
    {
        if (player.photonView.IsMine || game_manager.instance.is_develop_mode)
        {

            if (Input.GetButtonDown("Grab") && !game_manager.instance.localPlayer.GetComponent<player>().drop_flag)
            {
                if (mapObjectManager.interActiveGameObject != null)
                {
                    this.player.rig.velocity = Vector2.zero;
                    currentActivateObject = mapObjectManager.interActiveGameObject.gameObject.GetComponent<impl_observable>().Judgment();
                }
            }
            if (Input.GetButtonUp("Grab"))
            {
                if (currentActivateObject != null)
                {
                    currentActivateObject.GetComponent<impl_observable>().ActiveClear();
                    currentActivateObject = null;
                }
            }
        }
    }
}
