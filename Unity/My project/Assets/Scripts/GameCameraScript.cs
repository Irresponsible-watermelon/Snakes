using UnityEngine;

public class GameCameraScript : MonoBehaviour
{
    private Camera camera;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        camera = GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        if (camera.orthographicSize != DataManagerScript.Instance.zoom)
            camera.orthographicSize = DataManagerScript.Instance.zoom;
    }
}
