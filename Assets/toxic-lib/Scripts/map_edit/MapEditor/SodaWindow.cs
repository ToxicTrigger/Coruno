using UnityEngine;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
/// <summary>
///
/// </summary>
[ExecuteInEditMode]
public class SodaWindow : MonoBehaviour
{
    public Transform Up;
    public Transform Down;
    public Transform TileMap;
    public GameObject Pen;
    public bool EditMode;

    private void OnEnable()
    {
        if (!Application.isEditor)
        {
            Destroy(this);
        }
        SceneView.onSceneGUIDelegate += OnScene;
    }

    void OnScene(SceneView scene)
    {
        if (EditMode)
        {
            Event e = Event.current;
            Vector3 mousePos = e.mousePosition;
            float ppp = EditorGUIUtility.pixelsPerPoint;
            mousePos.y = scene.camera.pixelHeight - mousePos.y * ppp;
            mousePos.x *= ppp;
            Ray ray = scene.camera.ScreenPointToRay(mousePos);
            RaycastHit2D hit = Physics2D.Raycast(ray.origin, ray.direction, 1000);
            if (e.type == EventType.MouseUp && e.button == 2)
            {
                if (hit.collider != null && hit.collider.name.Contains("Tiled"))
                {
                    Debug.Log(hit.collider.transform.gameObject.name);
                    DestroyImmediate(hit.collider.transform.gameObject);
                }
                e.Use();
                return;
            }
            else if ((e.type == EventType.MouseDown || e.type == EventType.MouseDrag) && e.button == 2)
            {
                if (hit.collider == null)
                {
                    var realPos = scene.camera.ScreenToWorldPoint(mousePos);

                    var real = realPos;
                    real.z = 0;
                    real.x = real.x > 0 ? (int)real.x + 0.5f : (int)real.x - 0.5f;
                    real.y = real.y > 0 ? (int)real.y + 0.5f : (int)real.y - 0.5f;
                    GameObject tile = GameObject.Instantiate(Pen, real, Quaternion.identity, this.TileMap);
                    e.Use();
                }
            }
        }
    }
}
#else
public class SodaWindow : MonoBehaviour
{
    public Transform Up;
    public Transform Down;
    public Transform TileMap;
    public GameObject Pen;
    public bool EditMode;
}
#endif