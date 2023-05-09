using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamColorChange : MonoBehaviour
{
    public List<Material> mat;
    public Color MyColor_one, MyColor_two;
    Color before_one, before_two;
    Color current_one, current_two;
    public bool OnOff;

    [Range(0.1f, 3.0f)]
    public float Speed = 0.1f;
    public float Radius = 1.0f;

    private void Start()
    {
        var mats = Camera.main.transform.GetComponentsInChildren<MeshRenderer>();
        foreach (var item in mats)
        {
            if (item.name.Contains("gray_screen"))
            {
                mat.Add(item.sharedMaterials[0]);
                if (item.name.Contains("2"))
                {
                    before_two = this.mat[1].GetColor("_Color");
                }
                else
                {
                    before_one = this.mat[0].GetColor("_Color");
                }
            }
        }
    }

    private void Update()
    {
        if (mat == null) Debug.LogError("진원아 머테리얼 없다.");
        var dis = Vector2.Distance(this.transform.position, Camera.main.transform.position);
        if (dis < Radius)
        {
            current_two = Color.Lerp(current_two, MyColor_two, Time.deltaTime * Speed);
            mat[1].SetColor("_Color", current_two);
            current_one = Color.Lerp(current_one, MyColor_one, Time.deltaTime * Speed);
            mat[0].SetColor("_Color", current_one);
            this.OnOff = true;
        }
        else if (dis >= Radius || dis <= Radius + float.Epsilon)
        {
            current_two = Color.Lerp(current_two, before_two, Time.deltaTime * Speed);
            mat[1].SetColor("_Color", current_two);
            current_one = Color.Lerp(current_one, before_one, Time.deltaTime * Speed);
            mat[0].SetColor("_Color", current_one);
            this.OnOff = false;
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = MyColor_one;
        Gizmos.DrawWireSphere(this.transform.position, this.Radius);
    }

    private void OnDestroy()
    {
        mat[1].SetColor("_Color", before_two);
        mat[0].SetColor("_Color", before_one);
    }
}
