using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class tile_manager : trigger.impl_singletone<tile_manager>
{
    public float MapW, MapH;
    public float TileSize = 1;
    public bool On;
    public List<TIle> tiles;
    public SodaWindow mapEditor;
    public bool Bake;
    public bool Release;

    T CopyComponent<T>(T original, GameObject destination) where T : Component
    {
        System.Type type = original.GetType();
        var dst = destination.GetComponent(type) as T;
        dst = destination.AddComponent(type) as T;
        var fields = type.GetFields();
        foreach (var field in fields)
        {
            if (field.IsStatic) continue;
            field.SetValue(dst, field.GetValue(original));
        }
        var props = type.GetProperties();
        foreach (var prop in props)
        {
            if (!prop.CanWrite || !prop.CanWrite || prop.Name == "name") continue;
            prop.SetValue(dst, prop.GetValue(original, null), null);
        }
        return dst as T;
    }

    public void Start()
    {
        var TILES = GameObject.FindObjectsOfType<TIle>();
        mapEditor = game_manager.instance.GetComponent<SodaWindow>();
        foreach (var item in TILES)
        {
            tiles.Add(item);
        }

        if (Bake)
        {
            StartCoroutine(BakeTile());
        }
        else if(Release)
        {
            foreach (var item in tiles)
            {
                item.gameObject.transform.parent.gameObject.SetActive(false);
            }
        }
        else if(!Release && !Bake && game_manager.instance.is_develop_mode)
        {
            foreach (var item in tiles)
            {
                var offset = item.GetComponent<BoxCollider2D>().offset;
                if(offset.y > 0)
                {
                    offset.y -= 500;    
                }
                else
                {
                    offset.y += 500;    
                }
                item.GetComponent<BoxCollider2D>().offset = offset;
            }
        }
    }

    IEnumerator BakeTile()
    {
        int count = 0;
        foreach (var item in tiles)
        {
            item.gameObject.transform.parent.gameObject.SetActive(false);
            var box = item.GetComponent<BoxCollider2D>();
            box.usedByComposite = true;
            if (item.transform.position.y > 0)
            {
                box.offset = new Vector2(item.transform.position.x, item.transform.position.y - 500);
                item.transform.parent = mapEditor.Up;
                this.CopyComponent<BoxCollider2D>(box, mapEditor.Up.gameObject);
            }
            else
            {
                box.offset = new Vector2(item.transform.position.x, item.transform.position.y + 500);
                item.transform.parent = mapEditor.Down;
                this.CopyComponent<BoxCollider2D>(box, mapEditor.Down.gameObject);
            }
            Debug.Log("Per : " + ++count);
            Destroy(item.gameObject);
            yield return new WaitForFixedUpdate();
        }
    }

    private void OnDrawGizmos()
    {
        if (On)
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireCube(Vector3.zero + this.transform.position, new Vector3(MapW, MapH, 1));

            if (TileSize <= 0.3f)
            {
                Debug.LogError("승윤아 정신차려.");
            }
            else
            {
                Gizmos.color = Color.white;
                for (float y = -MapH / 2; y < ((MapH / 2) / TileSize); y += TileSize)
                {
                    for (float x = -MapW / 2; x < ((MapW / 2) / TileSize); x += TileSize)
                    {
                        Gizmos.DrawWireCube(new Vector3(x + TileSize / 2, y + TileSize / 2, 0) + this.transform.position, Vector3.one * TileSize * 1.0f);
                    }
                }
            }
        }

    }
}
