using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerPosChecker : MonoBehaviour
{
    public GameObject Target;
    public GameObject Player;
    public Image image;

    void Start()
    {
        image = this.GetComponent<Image>();
    }

    void Update()
    {
        if (game_manager.instance.RemotePlayer != null && Target == null)
        {
            this.Player = game_manager.instance.localPlayer;
            if (!game_manager.instance.is_develop_mode)
            {
                Target = game_manager.instance.RemotePlayer;
            }
            else
            {
                Target = game_manager.instance.start_points[0].gameObject;
            }
        }
        else
        {
            return;
        }

        var screen_player = Camera.main.WorldToScreenPoint(Player.transform.position);
        var screen_other  = Camera.main.WorldToScreenPoint(Target.transform.position);
        if (Vector2.Distance(screen_other, screen_player) >= 1920 / 2)
        {
            image.enabled = true;
            var look_dir = (screen_other - screen_player).normalized;
            var rot = CalculateAngle(screen_player, screen_other);
            rot.z += 90;
            float x = 900 * Mathf.Cos(rot.z * Mathf.Deg2Rad);
            float y = 400 * Mathf.Sin(rot.z * Mathf.Deg2Rad);
            this.transform.eulerAngles = rot;
            var pos = new Vector2(x, y);
            pos.x += 1920 / 2;
            pos.y += 1080 / 2;
            this.transform.position = pos;
        }
        else
        {
            image.enabled = false;
        }
    }

    public static Vector3 CalculateAngle(Vector3 from, Vector3 to)
    {
        return Quaternion.FromToRotation(Vector3.up, to - from).eulerAngles;
    }

}
