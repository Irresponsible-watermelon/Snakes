using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class DataManagerScript : MonoBehaviour
{
    public enum autopsy
    {
        RESTART,
        WALL,
        Self,
    }
    private static DataManagerScript _instance;
    public static DataManagerScript Instance {get => _instance; private set => _instance = value; }
    public bool is_initialised = false;
    public int difficulty = 3;
    public int zoom = 10;
    public int grid_size = 14;
    // Scores ordered ascending
    public List<int> ordered_scores {get; private set; }
    public autopsy cause_of_death;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(gameObject);
            return;
        }
        _instance = this;
        is_initialised = true;
        DontDestroyOnLoad(gameObject);
    }

private void OnDestroy()
    {
        if (_instance == this) _instance = null;
    }

//Give score to add to list, returns whether score is new highscore
public bool NewScore(int score)
    {
        ordered_scores.Add(score);
        ordered_scores.Sort();
        if (ordered_scores[ordered_scores.Count - 1] == score && ordered_scores[ordered_scores.Count - 2] != score) return true;
        else return false;
    }
}