<template>
  <div class="spinner-container">
    <div class="spinner-content">
      <svg
        class="spinner"
        width="65px"
        height="65px"
        viewBox="0 0 66 66"
        xmlns="http://www.w3.org/2000/svg"
      >
        <circle
          class="path"
          fill="none"
          stroke-width="6"
          stroke-linecap="round"
          cx="33"
          cy="33"
          r="30"
        ></circle>
      </svg>
      <br />
      <div class="spinner-message">{{ message }}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: "spinner",
  /**
   * Props the parent can use to manipulate this component.
   * Note: Components themselves should not mutate their own props.
   */
  props: {
    /**
     * The message displayed with the spinner
     */
    message: {
      type: String,
      default: "Loading...",
    },
  },
  data() {
    return {};
  },
  methods: {},
};
</script>

<style lang="scss" scoped>
$offset: 187;
$duration: 1.4s;
.spinner-container {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 999;
  background-color: rgba(
    52,
    73,
    94,
    0.5
  ); /* Changed to match our dark blue with transparency */
}
.spinner-content {
}
.spinner-message {
  padding: 4px 8px;
  border-radius: 8px;
  background-color: rgba(
    236,
    240,
    241,
    0.95
  ); /* Light background for message */
  color: #8e44ad; /* Purple to match our text color */
  font-weight: bold;
}
.spinner {
  animation: rotator $duration linear infinite;
  margin: auto;
}
@keyframes rotator {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(270deg);
  }
}
.path {
  stroke-dasharray: $offset;
  stroke-dashoffset: 0;
  transform-origin: center;
  animation: dash $duration ease-in-out infinite,
    colors ($duration * 4) ease-in-out infinite;
}
@keyframes colors {
  0% {
    stroke: #3498db;
  } /* Blue */
  25% {
    stroke: #9b59b6;
  } /* Purple */
  50% {
    stroke: #e74c3c;
  } /* Red */
  75% {
    stroke: #2ecc71;
  } /* Green */
  100% {
    stroke: #3498db;
  } /* Blue */
}
@keyframes dash {
  0% {
    stroke-dashoffset: $offset;
  }
  50% {
    stroke-dashoffset: $offset/4;
    transform: rotate(135deg);
  }
  100% {
    stroke-dashoffset: $offset;
    transform: rotate(450deg);
  }
}
</style>
