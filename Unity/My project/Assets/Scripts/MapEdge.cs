using System.Collections.Generic;
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
    public List<float> edge_positions {get ; private set;} = new List<float>();
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
{   
        establish();
    }

    void establish()
    {   
        while (edge_positions.Count < 4)
        {
            edge_positions.Add(0f);
        }
        
        edge_positions[0] = top_edge = TopWall.transform.position.y + cell_size;
        edge_positions[1] = bottom_edge = BottomWall.transform.position.y - cell_size;
        edge_positions[2] = left_edge = LeftWall.transform.position.x + cell_size;
        edge_positions[3] = right_edge = RightWall.transform.position.x - cell_size;

    
        transform.position = new Vector3(right_edge - left_edge, bottom_edge - top_edge, 0);
    }   
}
