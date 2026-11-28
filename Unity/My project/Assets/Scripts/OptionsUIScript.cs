using System;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.SceneManagement;
using Unity.VisualScripting;

public class OptionsUIScript : MonoBehaviour
{
    private PanelRenderer panel_renderer;
    private int ui_version = -1;
    private DataManagerScript singleton;
    private Snake snake_script;
    private Button close_button;
    private Button apply_button;
    private SliderInt difficulty_slider;
    private SliderInt grid_input;
    private SliderInt zoom_input;
    private HelpBox grid_alert;
    private Button alert_button;
    public int difficulty;
    public int grid_size;
    public int zoom;

    // Zoom range: 5 to 40, grid size range 12 to 72

    private void Awake()
    {
        singleton = DataManagerScript.Instance;
        PullSettings();
        panel_renderer = GetComponent<PanelRenderer>();
        
        if (SceneManager.GetSceneByName("Snake").isLoaded)
            {
                snake_script = FindAnyObjectByType<Snake>();
            }
        else snake_script = null;

        if (panel_renderer == null) return;

        panel_renderer.RegisterUIReloadCallback(OnUIReload);
    }

    void OnDestroy()
    {
        if (panel_renderer == null) return;

        panel_renderer.UnregisterUIReloadCallback(OnUIReload);
    }

    void OnUIReload(PanelRenderer renderer, VisualElement root, int version)
    {
        if (version == ui_version) return;
        ui_version = version;

        DifficultyReload(root);
        ZoomReload(root);
        GridSizeReload(root);
        CloseReload(root);
        ApplyReload(root);
        AlertReload(root);

        if (grid_alert != null) AlertButtonReload();
    }
// Input registerers
    void CloseReload(VisualElement root)
    {
        close_button = root.Q<Button>("CloseButton");
        close_button.clicked += OnClosePressed;
    }
    void ApplyReload(VisualElement root)
    {
        apply_button = root.Q<Button>("ApplyButton");
        apply_button.clicked += OnApplyPressed;
    }
    void AlertReload(VisualElement root)
    {
        grid_alert = root.Q<HelpBox>("GridAlert");
    }
    void AlertButtonReload()
    {
        alert_button = grid_alert.Q<Button>();
        alert_button.clicked += GridAlertAccept;
    }
    void DifficultyReload(VisualElement root)
    {
        if (difficulty_slider != null)
            difficulty_slider.UnregisterValueChangedCallback(OnDifficultySliderChanged);
        
        difficulty_slider = root.Q<SliderInt>("DifficultySliderInt");

        if (difficulty_slider == null)
        {
            Debug.LogError("DifficultySlider not found");
            return;
        }
        difficulty_slider.value = difficulty;
        difficulty_slider.RegisterValueChangedCallback(OnDifficultySliderChanged);
    }   
    void GridSizeReload(VisualElement root)
    {
        if (grid_input != null)
            grid_input.UnregisterValueChangedCallback(OnGridSizeChanged);

        grid_input = root.Q<SliderInt>("GridSliderInt");

        if (grid_input == null)
        {
            Debug.LogError("Grid size input not found");
            return;
        }
        grid_input.value = grid_size;
        grid_input.RegisterValueChangedCallback(OnGridSizeChanged);
        
    }
    void GridAlertAccept()
    {
        grid_alert.SetEnabled(false);
        grid_alert.visible = false;
    }
    void ZoomReload(VisualElement root)
    {
        if (zoom_input != null)
            zoom_input.UnregisterValueChangedCallback(OnZoomChanged);
        zoom_input = root.Q<SliderInt>("ZoomSliderInt");

        if (zoom_input == null)
        {
            Debug.LogError("Zoom input not found");
            return;
        }
        zoom_input.value = zoom;
        zoom_input.RegisterValueChangedCallback(OnZoomChanged);
            
    }   
    // Input handlers
    void OnClosePressed()
    {
        PushSettings();
        SceneManager.UnloadSceneAsync("Options");
    }
    void OnDifficultySliderChanged(ChangeEvent<int> eventData)
    {
        difficulty = eventData.newValue;   
    }
    void OnGridSizeChanged(ChangeEvent<int> eventData)
    {
        int grid_in = ((eventData.newValue + 1) / 2) * 2;
        if (snake_script != null)
        {
            if (IsSnakeInBox(grid_in))
            {   
                grid_size = grid_in;
                grid_input.SetValueWithoutNotify(grid_size);
                GridZoomSync(grid_size, true);
            }
            else
            {
                grid_input.SetValueWithoutNotify(grid_size);
                grid_alert.SetEnabled(true);
                grid_alert.visible = true;
            }
        }
        else grid_size = grid_in;

    }
    void OnZoomChanged(ChangeEvent<int> eventData)
    {
        zoom = eventData.newValue;
        GridZoomSync(zoom, false);
    }
    void OnApplyPressed()
    {
        PushSettings();
    }
    // Other Functions
    void PushSettings()
    {
        singleton.difficulty = difficulty;
        singleton.grid_size = grid_size;
        singleton.zoom = zoom;
    }
    void PullSettings()
    {
        difficulty = singleton.difficulty;
        if (difficulty_slider != null)
            difficulty_slider.value = difficulty;
        zoom = singleton.zoom;
        if (zoom_input != null)
            zoom_input.value = zoom;
        grid_size = singleton.grid_size;
        if (grid_input != null)
            grid_input.value = grid_size;
        
    }
    void GridZoomSync(int value_in, bool is_grid_in)
    {
        if (is_grid_in)
        {
            int new_grid_value = value_in;
            int min_zoom_value = (new_grid_value + 2) / 2;
            if (zoom < min_zoom_value)
            {
                zoom_input.value = min_zoom_value;
            } 
        }
        else
        {
            int new_zoom_value = value_in;
            int max_grid_value = (new_zoom_value * 2) - 2;
            if (grid_size > max_grid_value)
            {
                grid_input.value = max_grid_value;
            }
        }
        
    }
    bool IsSnakeInBox(int grid_in)
    {
        float min = 0 - ((grid_in - 1f) / 2f);
        float max = 0 + ((grid_in - 1f) / 2f);
 
        for (int i = 0; i < snake_script.body_parts.Count; i++)
        {
            float x = snake_script.body_parts[i].transform.position.x;
            float y = snake_script.body_parts[i].transform.position.y;

            if (x < min || x > max || y < min || y < max)
            {
                print($"Grid_size {grid_in} rejected by body part {i} at ({x}, {y}), with bounds set to min {min} and max {max}");
                return false;
            }
        }
        return true;
    }
}