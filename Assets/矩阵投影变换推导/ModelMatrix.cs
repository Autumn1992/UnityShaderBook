using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ModelMatrix : MonoBehaviour
{

    public Transform modelTrans;
    public Transform cameraTrans;

    /// <summary>
    /// 模型矩阵随时在变 当transform的transform信息发生改变时
    /// </summary>
    void Update()
    {
        Debug.LogError("modelMatrix:" + modelTrans.localToWorldMatrix.ToString());
    }

    /// <summary>
    /// ViewMatrix是右手坐标系 所以矩阵m23是-1 对z轴取反
    /// </summary>
    [ContextMenu("ShowCameraViewMatrix")]
    void ShowCameraViewMatrix()
    {
        Debug.LogError("ViewMatrix:" + cameraTrans.GetComponent<Camera>().worldToCameraMatrix);
        //Debug.LogError("AspectRatio:" + cameraTrans.GetComponent<Camera>().aspect);
    }
}
