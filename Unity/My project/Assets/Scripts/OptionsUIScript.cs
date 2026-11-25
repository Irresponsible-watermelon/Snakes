using System;
using UnityEngine;
using UnityEngine.UIElements;

public class OptionsUIScript : MonoBehaviour
{
    private PanelRenderer panel_renderer;
    private int ui_version = -1;
    private DataManagerScript singleton = DataManagerScript.Instance;

    private SliderInt difficulty_slider;
    private SliderInt grid_input;
    private SliderInt zoom_input;
    public int difficulty;
    public int grid_size;
    public int zoom;

    // Zoom range: 5 to 40, grid size range 12 to 72

    private void Awake()
    {
        panel_renderer = GetComponent<PanelRenderer>();

        if (panel_renderer = null) return;

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
    }

    void DifficultyReload(VisualElement root)
    {
        if (difficulty_slider != null)
            difficulty_slider.UnregisterValueChangedCallback(OnDifficultySliderChanged);
        
        difficulty_slider = root.Q<SliderInt>("DifficultySlider");

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
    void OnDifficultySliderChanged(ChangeEvent<int> eventData)
    {
        difficulty = eventData.newValue;   
    }
    void OnGridSizeChanged(ChangeEvent<int> eventData)
    {
        zoom = eventData.newValue;
    }
    void OnZoomChanged(ChangeEvent<int> eventData)
    {
        zoom = eventData.newValue;
    }
    void PushSettings()
    {
        singleton.difficulty = difficulty;
        singleton.grid_size = zoom;
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
    void CellZoomSync(int value_in, bool is_grid_in)
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
            int max_grid_value = (new_zoom_value - 2) * 2;
            if (grid_size > max_grid_value)
            {
                grid_input.value = max_grid_value;
            }
        }
        
    }
}
