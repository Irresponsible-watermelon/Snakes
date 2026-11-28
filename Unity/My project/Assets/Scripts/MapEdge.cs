using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class MapEdge : MonoBehaviour
{

    [SerializeField] private GameObject LeftWall;
    [SerializeField] private GameObject RightWall;
    [SerializeField] private GameObject TopWall;
    [SerializeField] private GameObject BottomWall;
    [SerializeField] private GameObject SnakeObject;

    private int cell_size = 1; 
    private float top_edge;
    private float bottom_edge;
    private float left_edge;
    private float right_edge;
    public List<float> edge_positions {get ; private set;} = new List<float>();
    private List<float> sample_edge_positions = new List<float>();
    private int grid_size => DataManagerScript.Instance.grid_size;
    private float wall_pos_from_cent => (grid_size + 2) / 2 ;
    private Vector3 wall_scale_vect_x => new Vector3(grid_size + 1.5f, 1, 0);
    private Vector3 wall_scale_vect_y => new Vector3(1, grid_size + 1.5f, 0);
    private int saved_grid;
    private BoxCollider2D collider;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
{   
        collider = this.GetComponent<BoxCollider2D>();
        saved_grid = grid_size;
        establish(false);
        
        
    }
    void Update()
    {
        if (grid_size != saved_grid)
        {
            saved_grid = grid_size;
            establish(true);
        }
    }

    void establish(bool is_update)
    {   

        if (is_update)
        {   
            GenerateSamplePositions();
            List<GameObject> snake_body_parts_list = SnakeObject.GetComponent<Snake>().body_parts;
            for (int i = 0; i < snake_body_parts_list.Count; i++)
            {
                if (snake_body_parts_list[i].transform.position.y > top_edge || snake_body_parts_list[i].transform.position.y < bottom_edge || snake_body_parts_list[i].transform.position.x < left_edge || snake_body_parts_list[i].transform.position.x > right_edge)
                {
                    return;
                }
            }
            edge_positions = new List<float>(sample_edge_positions);
            EdgePushToMap(edge_positions);
        }
        else EdgePullFromMap(edge_positions);

        collider.size = new Vector3(saved_grid - 1, saved_grid -1, 0);
    } 
    void EdgePullFromMap(List<float> edge_list)
    {
        while(edge_list.Count < 4) edge_list.Add(0f);

        edge_list[0] = top_edge = TopWall.transform.position.y - cell_size;
        edge_list[1] = bottom_edge = BottomWall.transform.position.y + cell_size;
        edge_list[2] = left_edge = LeftWall.transform.position.x + cell_size;
        edge_list[3] = right_edge = RightWall.transform.position.x - cell_size;
    }
    void EdgePushToMap(List<float> edge_list)
    {
        top_edge = edge_list[0];
        bottom_edge = edge_list[1];
        left_edge = edge_list[2];
        right_edge = edge_list[3];

        TopWall.transform.localScale = wall_scale_vect_x;
        BottomWall.transform.localScale = wall_scale_vect_x;
        LeftWall.transform.localScale = wall_scale_vect_y;
        RightWall.transform.localScale = wall_scale_vect_y;

        TopWall.transform.position = new Vector3(0, 0 + wall_pos_from_cent, 0);
        BottomWall.transform.position = new Vector3(0, 0 - wall_pos_from_cent, 0);
        LeftWall.transform.position = new Vector3(0 - wall_pos_from_cent, 0, 0);
        RightWall.transform.position = new Vector3 (0 + wall_pos_from_cent, 0, 0); 
    }
    void GenerateSamplePositions()
    {
        sample_edge_positions = new List<float>
        {
          0 + wall_pos_from_cent,
          0 - wall_pos_from_cent,
          0 - wall_pos_from_cent,
          0 + wall_pos_from_cent, 
        };
    }
}   
