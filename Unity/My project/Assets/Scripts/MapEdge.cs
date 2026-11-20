using UnityEngine;

public class MapEdge : MonoBehaviour
{

    [SerializeField] private GameObject LeftWall;
    [SerializeField] private GameObject RightWall;
    [SerializeField] private GameObject TopWall;
    [SerializeField] private GameObject BottomWall;

    private int cell_size = 1; 
    private float top_edge;
    private float bottom_edge;
    private float left_edge;
    private float right_edge; 
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
    {
        establish();
    }

    void establish()
    {
        top_edge = TopWall.transform.position.y + cell_size;
        bottom_edge = BottomWall.transform.position.y - cell_size;
        left_edge = LeftWall.transform.position.x + cell_size;
        right_edge = RightWall.transform.position.x - cell_size;
    }   
}
